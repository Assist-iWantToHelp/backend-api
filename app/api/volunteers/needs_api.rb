module Volunteers
  class NeedsApi < Grape::API
    use Grape::Knock::Authenticable

    before { authorize_user_role! }

    resource :needs do
      desc "Other's needs" do
        tags %w[needs]
        http_codes [
          { code: 200, model: Entities::Need, message: "Other's needs list" }
        ]
      end
      get do
        needs = Need.opened.where.not(added_by: current_user) # TODO: - search by proximity or other filter
        present needs, with: Entities::Need
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
          need = Need.opened.where.not(added_by: current_user).find(params[:id])
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
          need = Need.opened.where.not(added_by: current_user).find(params[:id])

          if need.chosen_by.blank?
            need.update_attributes(
              status: Need.statuses[:in_progress],
              chosen_by: current_user
            )
            # TODO: - create a service object to send notification
            present need, with: Entities::Need
          else
            status :conflict
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
          need = current_user.chosen_needs.find(params[:id])

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
              status_updated_at: DateTime.now,
              updated_by: current_user.id
            )
            present need, with: Entities::Need
          else
            status :bad_request
            error!('Need is not in progress', 400)
          end
        end
      end

      resource :recommended do
        desc 'My recommended needs' do
          tags %w[recommended_needs]
          http_codes [
            { code: 200, model: Entities::Need, message: 'My recommended needs list' }
          ]
        end
        get do
          needs = current_user.my_needs
          present needs, with: Entities::RecommendedNeed
        end

        desc 'Recommend a person in need' do
          tags %w[recommended_needs]
          http_codes [
            { code: 201, model: Entities::RecommendedNeed, message: 'Need created' },
            { code: 400, message: 'Params are invalid' }
          ]
        end
        params do
          with(documentation: { in: 'body' }) do
            requires :description, type: String, desc: 'Description', allow_blank: false
            requires :contact_info, type: String, desc: 'Contact info', allow_blank: false
            requires :contact_phone_number, type: String, desc: 'Contact phone number', allow_blank: false
          end
        end
        post do
          need = current_user.my_needs.create!(params)
          present need, with: Entities::RecommendedNeed
        end

        route_param :id do
          desc 'Get specific recommended need' do
            tags %w[recommended_needs]
            http_codes [
              { code: 200, model: Entities::Need, message: 'Recommended need description' },
              { code: 404, message: 'Need not found' }
            ]
          end
          get do
            need = current_user.my_needs.find(params[:id])
            present need, with: Entities::Need
          end

          desc 'Update recommended need' do
            tags %w[recommended_needs]
            http_codes [
              { code: 200, model: Entities::Need, message: 'Recommended Need description' },
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
              params[:status_updated_at] = DateTime.now
              params[:updated_by] = current_user.id
              need.update!(params)
              present need, with: Entities::Need
            else
              status :bad_request
              error!('Need is not opened anymore', 400)
            end
          end

          desc 'Delete recommended need' do
            tags %w[recommended_needs]
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

          desc 'Confirm completed recommended need (close)' do
            tags %w[recommended_needs]
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

              need.update!(status: Need.statuses[:closed], status_updated_at: DateTime.now, updated_by: current_user.id)
              need.reviews.create!(review_params)

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
end
