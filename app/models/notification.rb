class Notification < ApplicationRecord
  enum status: { created: 0, read: 1 }

  belongs_to :user

  validates :description, presence: true
end
