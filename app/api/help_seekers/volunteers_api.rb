module HelpSeekers
  class VolunteersApi < Grape::API
    use Grape::Knock::Authenticable

    before { authorize_user_role! }

    resource :volunteers do
      desc 'Volunteers that helped me' do
        tags %w[volunteers]
        http_codes [
          { code: 200, model: Entities::Volunteer, message: 'Volunteers list' }
        ]
      end
      get do
        volunteers = current_user.my_needs.includes(:chosen_by).map(&:chosen_by)
        present volunteers, with: Entities::Volunteer
      end
    end
  end
end
