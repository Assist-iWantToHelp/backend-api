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
        needs = Need.opened # TODO: - search by proximity or other filter
        present needs, with: Entities::Need
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
    end
  end
end
