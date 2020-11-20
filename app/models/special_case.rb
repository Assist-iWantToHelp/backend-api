class SpecialCase < ApplicationRecord
  enum status: { opened: 0, closed: 1 }

  belongs_to :user

  alias added_by user

  has_many :user_special_cases

  validates :description, presence: true
end
