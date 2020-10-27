# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false

  def create
    @user = User.new(user_params)
    if @user.save
      head :created
    else
      render json: @user.errors.messages, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:auth).permit(:phone_number, :email, :password, :password_confirmation)
  end
end
