class Address < ApplicationRecord
  has_one :user

  validates :street_name, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true
end
