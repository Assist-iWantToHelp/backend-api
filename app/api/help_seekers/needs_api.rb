module HelpSeekers
  class NeedsApi < Grape::API
    use Grape::Knock::Authenticable

    before { authorize_user_role! }

    resource :my_needs do
      desc 'Get my needs' do
        tags %w[needs]
        http_codes [
          { code: 200, model: Entities::Need, message: 'Needs list' }
        ]
      end
      get do
        needs = current_user.my_needs.not_deleted
        present needs, with: Entities::Need
      end

      desc 'Create new need' do
        tags %w[needs]
        http_codes [
          { code: 201, model: Entities::Need, message: 'Need created' },
          { code: 400, message: 'Params are invalid' }
        ]
      end
      params do
        with(documentation: { in: 'body' }) do
          requires :category, type: String, desc: 'Category', values: Need.categories.keys
          requires :description, type: String, desc: 'Description', allow_blank: false
        end
      end

      post do
        need = current_user.my_needs.create!(params)

        device_tokens = User.volunteers.includes(:devices).map(&:devices).flatten.pluck(:signal_id)
        notification_payload = {
          template_key: 'applied_need',
          url: "#{ENV['FE_NEED_VIEW']}/#{need.id}"
        }
        Onesignal.deliver(device_tokens, notification_payload)

        present need, with: Entities::Need
      end

      route_param :id do
        desc 'Get specific need' do
          tags %w[needs]
          http_codes [
            { code: 200, model: Entities::Need, message: 'Need description' },
            { code: 404, message: 'Need not found' }
          ]
        end
        get do
          need = current_user.my_needs.not_deleted.find(params[:id])
          present need, with: Entities::Need
        end

        desc 'Update need' do
          tags %w[needs]
          http_codes [
            { code: 200, model: Entities::Need, message: 'Need description' },
            { code: 400, message: 'Params are invalid' },
            { code: 404, message: 'Need not found' },
            { code: 409, message: 'Need is not opened anymore' }
          ]
        end
        params do
          with(documentation: { in: 'body' }) do
            optional :description, type: String, desc: 'Description', allow_blank: false
            optional :category, type: String, desc: 'Category', allow_blank: false, values: Need.categories.keys
            optional :contact_info, type: String, desc: 'Contact info', allow_blank: false
            optional :contact_phone_number, type: String, desc: 'Contact phone number', allow_blank: false
          end
        end
        put do
          need = current_user.my_needs.not_deleted.find(params[:id])

          if need.opened?
            params[:status_updated_at] = DateTime.current
            params[:updated_by_id] = current_user.id
            need.update!(params)
            present need, with: Entities::Need
          else
            error!('Need is not opened anymore', 409)
          end
        end

        desc 'Delete need' do
          tags %w[needs]
          http_codes [
            { code: 204, message: 'No content' },
            { code: 409, message: 'Need is not opened anymore' },
            { code: 404, message: 'Need not found' }
          ]
        end
        delete do
          need = current_user.my_needs.not_deleted.find(params[:id])

          if need.opened?
            need.update!(
              deleted: true,
              updated_by_id: current_user.id,
              status_updated_at: DateTime.current
            )
            status :no_content
          else
            error!('Need is not opened anymore', 409)
          end
        end

        desc 'Confirm completed need (close)' do
          tags %w[needs]
          http_codes [
            { code: 201, model: Entities::Need, message: 'Need confirmed and review added' },
            { code: 400, message: 'Params are invalid' },
            { code: 404, message: 'Need not found' },
            { code: 409, message: 'Need is not completed' }
          ]
        end
        params do
          with(documentation: { in: 'body' }) do
            requires :review, type: Hash, allow_blank: false do
              requires :stars, type: Integer, values: 1..5, allow_blank: false
              optional :comment, type: String, allow_blank: false
            end
          end
        end
        post :close do
          need = current_user.my_needs.not_deleted.includes(:reviews).find(params[:id])

          if need.completed? && need.chosen_by
            review_params = params[:review].merge(
              provided_by_id: current_user.id,
              given_to_id: need.chosen_by.id
            )

            need.reviews.create!(review_params)
            need.update!(
              status: Need.statuses[:closed],
              status_updated_at: DateTime.current,
              updated_by_id: current_user.id
            )

            device_tokens = need.chosen_by&.devices&.pluck(:signal_id)
            notification_payload = {
              template_key: 'confirmed_need',
              url: "#{ENV['FE_NEED_VIEW']}/#{need.id}"
            }
            Onesignal.deliver(device_tokens, notification_payload)

            present need, with: Entities::Need
          else
            error!('Need is not completed', 409)
          end
        end
      end
    end
  end
end
