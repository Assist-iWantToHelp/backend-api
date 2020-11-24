# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false

  def create
    @user = User.new(user_params)

    if @user.save
      response = {
        user: @user.as_json(
          include: :address,
          except: %i[created_at updated_at password_digest]
        )
      }
      render json: response, status: :created
    else
      render json: @user.errors.messages, status: :unprocessable_entity
    end
  rescue StandardError
    render json: { 'role': ['is not a valid role'] }, status: :unprocessable_entity
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
      :description,
      address_attributes: %i[
        street_name
        city
        county
        postal_code
        coordinates
        details
      ]
    )
  end
end
