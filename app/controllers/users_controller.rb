# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false

  def create
    begin
      @user = User.new(user_params)
      if @user.save
        head :created
      else
        render json: @user.errors.messages, status: :unprocessable_entity
      end
    rescue
      return render json: {'role': ['is not a valid role']}, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:auth).permit(
      :phone_number,
      :first_name,
      :last_name,
      :email,
      :cif,
      :role,
      :password,
      :password_confirmation,
      :address_id
      )
  end
end
