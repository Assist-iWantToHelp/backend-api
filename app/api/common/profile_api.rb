module Common
  class ProfileApi < Grape::API
    use Grape::Knock::Authenticable

    before { authorize_user_role! }

    resource :profile do
      desc 'Get my profile' do
        tags %w[profile]
        http_codes [
          { code: 200, model: Entities::Profile, message: 'Profile overview' }
        ]
      end
      get do
        profile = current_user
        present profile, with: Entities::Profile
      end

      desc 'Update profile' do
        tags %w[profile]
        http_codes [
          { code: 200, model: Entities::Profile, message: 'Profile update' },
          { code: 400, message: 'Params are invalid' }
        ]
      end
      params do
        with(documentation: { in: 'body' }) do
          optional :phone_number, type: String, desc: 'Phone number', allow_blank: false
          optional :first_name, type: String, desc: 'First name', allow_blank: false
          optional :last_name, type: String, desc: 'Last name', allow_blank: false
          optional :email, type: String, desc: 'Email', allow_blank: false
        end
      end
      put do
        profile = current_user
        profile.update!(params)
        present profile, with: Entities::Profile
      end
    end
  end
end
