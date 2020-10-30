class User < ApplicationRecord
  has_secure_password
  has_many :needs

  validates :phone_number, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  enum role: %i[help_seeker volunteer ngo admin]

  def self.from_token_request(request)
    User.find_by(phone_number: request.params[:auth][:phone_number])
  end
end
