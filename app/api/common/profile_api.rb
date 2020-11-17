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
        profile = current_user
        profile.update!(permitted_params)
        present profile, with: Entities::Profile
      end
    end
  end
end
