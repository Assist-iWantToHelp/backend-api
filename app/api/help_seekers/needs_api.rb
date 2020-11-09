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
        needs = current_user.my_needs
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
          requires :description, type: String, desc: 'Description', allow_blank: false
        end
      end
      post do
        need = current_user.my_needs.create!(params)
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
          need = current_user.my_needs.find(params[:id])
          present need, with: Entities::Need
        end

        desc 'Update need' do
          tags %w[needs]
          http_codes [
            { code: 200, model: Entities::Need, message: 'Need description' },
            { code: 400, message: 'Params are invalid' },
            { code: 404, message: 'Need not found' }
          ]
        end
        params do
          with(documentation: { in: 'body' }) do
            optional :description, type: String, desc: 'Description', allow_blank: false
            optional :contact_info, type: String, desc: 'Contact info', allow_blank: false
            optional :contact_phone_number, type: String, desc: 'Contact phone number', allow_blank: false
          end
        end
        put do
          need = current_user.my_needs.find(params[:id])

          if need.opened?
            need.update!(params)
            present need, with: Entities::Need
          else
            status :bad_request
            error!('Need is not opened anymore', 400)
          end
        end

        desc 'Delete need' do
          tags %w[needs]
          http_codes [
            { code: 204, message: 'No content' },
            { code: 400, message: 'Need is not opened anymore' },
            { code: 404, message: 'Need not found' }
          ]
        end
        delete do
          need = current_user.my_needs.find(params[:id])
          if need.opened?
            need.update!(deleted: true)
            status :no_content
          else
            status :bad_request
            error!('Need is not opened anymore', 400)
          end
        end

        desc 'Confirm completed need (close)' do
          tags %w[needs]
          http_codes [
            { code: 201, model: Entities::Need, message: 'Need confirmed and review added' },
            { code: 400, message: 'Params are invalid' },
            { code: 404, message: 'Need not found' },
            { code: 409, message: 'Conflict' }
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
          need = current_user.my_needs.includes(:reviews).find(params[:id])

          if need.completed? && need.chosen_by
            review_params = params[:review].merge(
              provided_by_id: current_user.id,
              given_to_id: need.chosen_by.id
            )

            need.reviews.create!(review_params)
            need.closed!

            present need, with: Entities::Need
          else
            status :bad_request
            error!('Need is not completed', 400)
          end
        end
      end
    end
  end
end
