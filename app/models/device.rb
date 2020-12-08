class Device < ApplicationRecord
  belongs_to :user

  validates :signal_id, presence: true
end
