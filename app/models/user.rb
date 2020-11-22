class User < ApplicationRecord
  has_secure_password

  enum role: { help_seeker: 0, volunteer: 1, ngo: 2, admin: 3 }

  has_one :address, as: :addressable

  has_one :testimonial

  has_many :my_needs, class_name: 'Need', foreign_key: 'added_by_id'
  has_many :chosen_needs, class_name: 'Need', foreign_key: 'chosen_by_id'
  has_many :updated_needs, class_name: 'Need', foreign_key: 'updated_by_id'

  has_many :provided_reviews, class_name: 'Review', foreign_key: 'provided_by_id'
  has_many :given_reviews, class_name: 'Review', foreign_key: 'given_to_id'

  has_many :notifications
  has_many :user_special_cases
  has_many :special_cases

  validates :phone_number, presence: true, uniqueness: true
  validates :first_name, presence: true

  accepts_nested_attributes_for :address, update_only: true

  scope :volunteers, -> { where(role: %i[volunteer ngo]) }

  def self.from_token_request(request)
    User.find_by(phone_number: request.params[:auth][:phone_number])
  end
end
