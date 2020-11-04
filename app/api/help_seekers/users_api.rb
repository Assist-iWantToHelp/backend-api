module HelpSeekers
  class UsersApi < Grape::API
    use Grape::Knock::Authenticable

    resource :users do
      desc 'Get my profile' do
        tags %w[users]
        http_codes [
                       { code: 200, model: Entities::HelpSeeker, message: 'Profile overview' }
                   ]
      end
      get do
        profile = current_user
        present profile, with: Entities::HelpSeeker
      end

      desc 'Update profile' do
        tags %w[users]
        http_codes [
                       { code: 200, model: Entities::HelpSeeker, message: 'Profile update' },
                       { code: 400, message: 'Params are invalid' },
                       { code: 404, message: 'Profile not found' }
                   ]
      end
      params do
        with(documentation: { in: 'body' }) do
          optional :phone_number, type: String, desc: 'Phone number', allow_blank: false
          optional :first_name, type: String, desc: 'First name', allow_blank: false
          optional :last_name, type: String, desc: 'Last name', allow_blank: false
        end
      end
      put do
        profile = current_user
        profile.update!(params)
        present profile, with: Entities::HelpSeeker
      end
    end
  end
end

