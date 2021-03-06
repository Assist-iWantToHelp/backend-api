module Volunteers
  class NeedsApi < Grape::API
    use Grape::Knock::Authenticable

    before { authorize_user_role! }

    resource :needs do
      desc "Other's needs" do
        tags %w[needs]
        http_codes [
          { code: 200, model: Entities::BasicNeed, message: "Other's needs list" }
        ]
      end
      get do
        # TODO: - search by proximity or other filter
        needs = Need.not_deleted.opened.where.not(added_by: current_user)
          .or(Need.not_deleted.where(chosen_by: current_user))
        present needs, with: Entities::BasicNeed
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
          need = Need.not_deleted.opened.where.not(added_by: current_user)
            .or(Need.not_deleted.where(chosen_by: current_user)).find(params[:id])
          present need, with: Entities::Need
        end

        desc 'Apply to help' do
          tags %w[needs]
          http_codes [
            { code: 200, model: Entities::Need, message: 'Need description' },
            { code: 400, message: 'Bad request' },
            { code: 404, message: 'Need not found' },
            { code: 409, message: 'Need is chosen already' }
          ]
        end
        post :apply do
          need = Need.not_deleted.opened.where.not(added_by: current_user).find(params[:id])

          if need.chosen_by.blank?
            need.update_attributes(
              status: Need.statuses[:in_progress],
              chosen_by_id: current_user.id,
              updated_by_id: current_user.id,
              status_updated_at: DateTime.current
            )

            device_tokens = need.added_by&.devices&.pluck(:signal_id)
            notification_payload = { template_key: 'applied_need' }
            if need.added_by.help_seeker?
              notification_payload[:data] = { need_id: need.id }
            else
              notification_payload[:url] = "#{ENV['FE_NEED_VIEW']}/#{need.id}"
            end
            Onesignal.deliver(device_tokens, notification_payload)

            present need, with: Entities::Need
          else
            error!('Need is chosen already', 409)
          end
        end

        desc 'Mark need as completed' do
          tags %w[needs]
          http_codes [
            { code: 200, model: Entities::Need, message: 'Need description' },
            { code: 400, message: 'Bad request' },
            { code: 404, message: 'Need not found' },
            { code: 409, message: 'Need is not in progress' }
          ]
        end
        params do
          with(documentation: { in: 'body' }) do
            optional :review, type: Hash, allow_blank: false do
              requires :stars, type: Integer, values: 1..5, allow_blank: false
              optional :comment, type: String, allow_blank: false
            end
          end
        end
        post :completed do
          need = current_user.chosen_needs.not_deleted.find(params[:id])

          if need.in_progress?
            if params[:review]
              review_params = params[:review].merge(
                provided_by_id: current_user.id,
                given_to_id: need.added_by.id
              )
              need.reviews.create!(review_params)
            end

            need.update!(
              status: Need.statuses[:completed],
              status_updated_at: DateTime.current,
              updated_by_id: current_user.id
            )
            present need, with: Entities::Need
          else
            error!('Need is not in progress', 409)
          end
        end
      end
    end
  end
end
