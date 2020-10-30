class SpecialCase < ApplicationRecord
  belongs_to :user
  has_many :user_special_cases

  validates :description, presence: true
end
