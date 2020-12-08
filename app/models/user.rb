class User < ApplicationRecord
  has_secure_password

  enum role: { help_seeker: 0, volunteer: 1, ngo: 2, admin: 3 }

  has_one :address, as: :addressable

  has_one :testimonial
  has_one :questionnaire

  has_many :my_needs, class_name: 'Need', foreign_key: 'added_by_id'
  has_many :chosen_needs, class_name: 'Need', foreign_key: 'chosen_by_id'
  has_many :updated_needs, class_name: 'Need', foreign_key: 'updated_by_id'

  has_many :provided_reviews, class_name: 'Review', foreign_key: 'provided_by_id'
  has_many :received_reviews, class_name: 'Review', foreign_key: 'given_to_id'

  has_many :notifications
  has_many :user_special_cases
  has_many :special_cases
  has_many :devices

  validates :phone_number, presence: true, uniqueness: true
  validates :first_name, presence: true

  accepts_nested_attributes_for :address, update_only: true

  scope :volunteers, -> { where(role: %i[volunteer ngo]) }

  def self.from_token_request(request)
    User.find_by(phone_number: request.params[:auth][:phone_number])
  end

  def received_rating
    return 0 if received_reviews.blank?

    total_stars = received_reviews.map(&:stars).reduce(:+).to_f
    total_stars / received_reviews.count
  end

  def questionnaire_completed
    questionnaire ? true : false
  end

  def trusted_volunteer
    questionnaire_completed && confidence_mean >= TRUST_THRESHOLD
  end

  private

  TRUST_THRESHOLD = 3.5

  def public_key
    Paillier::PublicKey.from_s(ENV['PAILLIER_PUBLIC'])
  end

  def private_key
    Paillier::PrivateKey.from_s(ENV['PAILLIER_PRIVATE'])
  end

  def confidence_mean
    return 0 unless questionnaire

    total = Paillier.decrypt(private_key, public_key, questionnaire&.total).to_i
    total / 5.0
  end
end
