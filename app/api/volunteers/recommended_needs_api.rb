module Volunteers
  class RecommendedNeedsApi < Grape::API
    use Grape::Knock::Authenticable

    before { authorize_user_role! }

    namespace :recommended_needs do
      desc 'My recommended needs' do
        tags %w[recommended_needs]
        http_codes [
          { code: 200, model: Entities::RecommendedNeed, message: 'My recommended needs list' }
        ]
      end
      get do
        needs = current_user.my_needs.not_deleted
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
          requires :category, type: String, desc: 'Category', allow_blank: false, values: Need.categories.keys
          requires :contact_phone_number, type: String, desc: 'Contact phone number', allow_blank: false
          requires :contact_first_name, type: String, desc: 'Contact first name', allow_blank: false
          optional :contact_last_name, type: String, desc: 'Contact last name', allow_blank: false
          requires :address, type: Hash do
            requires :street_name, type: String, allow_blank: false
            requires :city, type: String, allow_blank: false
            requires :county, type: String, allow_blank: false
            requires :postal_code, type: String, allow_blank: false
            optional :coordinates, type: String, allow_blank: false
            optional :details, type: String, allow_blank: false
          end
        end
      end
      route_setting :aliases, address: :address_attributes

      post do
        need = current_user.my_needs.create!(permitted_params)

        device_tokens = User.volunteers
          .where.not(id: current_user.id)
          .includes(:devices)
          .map(&:devices).flatten
          .pluck(:signal_id)
        notification_payload = {
          template_key: 'new_recommended_need',
          url: "#{ENV['FE_RECOMMENDED_NEED_VIEW']}/#{need.id}"
        }
        Onesignal.deliver(device_tokens, notification_payload)

        present need, with: Entities::RecommendedNeed
      end

      route_param :id do
        desc 'Get specific recommended need' do
          tags %w[recommended_needs]
          http_codes [
            { code: 200, model: Entities::RecommendedNeed, message: 'Recommended need description' },
            { code: 404, message: 'Need not found' }
          ]
        end
        get do
          need = current_user.my_needs.not_deleted.find(params[:id])
          present need, with: Entities::RecommendedNeed
        end

        desc 'Update recommended need' do
          tags %w[recommended_needs]
          http_codes [
            { code: 200, model: Entities::RecommendedNeed, message: 'Recommended Need description' },
            { code: 400, message: 'Params are invalid' },
            { code: 404, message: 'Need not found' },
            { code: 409, message: 'Need is not opened anymore' }
          ]
        end
        params do
          with(documentation: { in: 'body' }) do
            optional :description, type: String, desc: 'Description', allow_blank: false
            optional :category, type: String, desc: 'Category', allow_blank: false, values: Need.categories.keys
            optional :contact_phone_number, type: String, desc: 'Contact phone number', allow_blank: false
            optional :contact_first_name, type: String, desc: 'Contact first name', allow_blank: false
            optional :contact_last_name, type: String, desc: 'Contact last name', allow_blank: false
            optional :address, type: Hash do
              optional :street_name, type: String, allow_blank: false
              optional :city, type: String, allow_blank: false
              optional :county, type: String, allow_blank: false
              optional :postal_code, type: String, allow_blank: false
              optional :coordinates, type: String, allow_blank: false
              optional :details, type: String, allow_blank: false
            end
          end
        end
        route_setting :aliases, address: :address_attributes

        put do
          need = current_user.my_needs.not_deleted.find(params[:id])

          if need.opened?
            params[:status_updated_at] = DateTime.current
            params[:updated_by_id] = current_user.id
            need.update!(permitted_params)
            present need, with: Entities::RecommendedNeed
          else
            error!('Need is not opened anymore', 409)
          end
        end

        desc 'Delete recommended need' do
          tags %w[recommended_needs]
          http_codes [
            { code: 204, message: 'No content' },
            { code: 404, message: 'Need not found' },
            { code: 409, message: 'Need is not opened anymore' }
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

        desc 'Confirm completed recommended need (close)' do
          tags %w[recommended_needs]
          http_codes [
            { code: 201, model: Entities::RecommendedNeed, message: 'Need confirmed and review added' },
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

            need.update!(
              status: Need.statuses[:closed],
              status_updated_at: DateTime.current,
              updated_by_id: current_user.id
            )
            need.reviews.create!(review_params)

            device_tokens = need.chosen_by&.devices&.pluck(:signal_id)
            notification_payload = {
              template_key: 'confirmed_need',
              url: "#{ENV['FE_RECOMMENDED_NEED_VIEW']}/#{need.id}"
            }
            Onesignal.deliver(device_tokens, notification_payload)

            present need, with: Entities::RecommendedNeed
          else
            error!('Need is not completed', 409)
          end
        end
      end
    end
  end
end
