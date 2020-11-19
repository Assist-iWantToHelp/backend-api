module Volunteers
  class HelpedPeopleApi < Grape::API
    use Grape::Knock::Authenticable

    before { authorize_user_role! }

    resource :helped_people do
      desc 'People helpers by me' do
        tags %w[helped_people]
        http_codes [
          { code: 200, model: Entities::HelpSeeker, message: 'Helped people list' }
        ]
      end
      get do
        helped_people = current_user.chosen_needs.includes(:added_by).map(&:added_by).uniq
        present helped_people, with: Entities::HelpSeeker
      end
    end
  end
end
