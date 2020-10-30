class UserSpecialCase < ApplicationRecord
  belongs_to :special_case
  belongs_to :user

  validates :promotion_description, presence: true
end
