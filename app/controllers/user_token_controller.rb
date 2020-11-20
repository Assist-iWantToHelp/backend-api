class UserTokenController < Knock::AuthTokenController
  skip_before_action :verify_authenticity_token, raise: false

  def create
    user = User.find_by(id: auth_token.payload[:sub])

    response = {
      jwt: auth_token.token,
      user: user.as_json(
        include: :address,
        except: %i[created_at updated_at password_digest]
      )
    }

    render json: response, status: :created
  end

  private

  def auth_params
    params.require(:auth).permit(:phone_number, :password)
  end
end
