class SpecialCase < ApplicationRecord
  belongs_to :user
  has_many :user_special_cases

  alias added_by user

  validates :description, presence: true
end
