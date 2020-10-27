class User < ApplicationRecord
  has_secure_password

  validates :phone_number, presence: true
  validates :phone_number, uniqueness: true

  def self.from_token_request(request)
    User.find_by(phone_number: request.params[:auth][:phone_number])
  end
end
