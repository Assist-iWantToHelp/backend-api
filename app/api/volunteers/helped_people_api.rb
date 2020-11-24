module Volunteers
  class HelpedPeopleApi < Grape::API
    use Grape::Knock::Authenticable

    before { authorize_user_role! }

    resource :helped_people do
      desc 'People helpers by me' do
        tags %w[helped_people]
        http_codes [
          { code: 200, model: Entities::BasicHelpSeeker, message: 'Helped people list' }
        ]
      end
      get do
        helped_people = current_user.chosen_needs.includes(:added_by).map(&:added_by).uniq
        present helped_people, with: Entities::BasicHelpSeeker
      end

      route_param :id do
        desc 'Get specific helped person' do
          tags %w[helped_people]
          http_codes [
            { code: 200, model: Entities::HelpSeeker, message: 'HelpSeeker description' },
            { code: 404, message: 'HelpSeeker not found' }
          ]
        end
        get do
          help_seeker = User.find(params[:id])

          present help_seeker, with: Entities::HelpSeeker
        end
      end
    end
  end
end
