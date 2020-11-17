class Address < ApplicationRecord
  belongs_to :user

  validates :street_name, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true
end
