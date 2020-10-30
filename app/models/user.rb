class User < ApplicationRecord
  has_secure_password
  has_many :my_needs, class_name: 'Need', foreign_key: 'added_by_id'
  has_many :chosen_needs, class_name: 'Need', foreign_key: 'chosen_by_id'

  validates :phone_number, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  # enum role: %i[help_seeker volunteer ngo admin]
  enum role: { help_seeker: 0, volunteer: 1, ngo: 2, admin: 3 }

  def self.from_token_request(request)
    User.find_by(phone_number: request.params[:auth][:phone_number])
  end
end
