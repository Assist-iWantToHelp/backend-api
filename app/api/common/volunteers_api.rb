module Common
  class VolunteersApi < Grape::API
    resource :volunteers do
      desc 'Volunteers' do
        tags %w[volunteers]
        http_codes [
          { code: 200, model: Entities::Volunteer, message: 'Volunteers list' }
        ]
      end
      get do
        volunteers = User.volunteers.includes(:received_reviews).sort_by(&:received_rating).reverse
        present volunteers, with: Entities::Volunteer
      end
    end
  end
end
