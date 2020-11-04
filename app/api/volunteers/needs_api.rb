module Volunteers
  class NeedsApi < Grape::API
    use Grape::Knock::Authenticable

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
          need = Need.okbpened.where.not(added_by: current_user).find(params[:id])
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
        post do
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
              need.update!(params)
              present need, with: Entities::Need
            else
              status :bad_request
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
            end
          end
        end
      end
    end
  end
end