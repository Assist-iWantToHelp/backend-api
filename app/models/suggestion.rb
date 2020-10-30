class Suggestion < ApplicationRecord
  validates :email, presence: true
  validates :name, presence: true
  validates :message, presence: true
end
