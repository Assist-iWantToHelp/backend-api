class Notification < ApplicationRecord
  belongs_to :user

  validates :description, presence: true

  enum status: { created: 0, read: 1 }
end
