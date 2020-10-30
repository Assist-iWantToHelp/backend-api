class UserTokenController < Knock::AuthTokenController
  skip_before_action :verify_authenticity_token, raise: false

  private

  def auth_params
    params.require(:auth).permit(:phone_number, :password)
  end
end
