class UserSpecialCase < ApplicationRecord
  belongs_to :special_case
  belongs_to :user

  alias sustained_by user

  validates :promotion_description, presence: true
end
