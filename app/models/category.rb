class Category < ApplicationRecord
  has_many :needs

  validates :name, presence: true, uniqueness: { case_sensitive: true }
end
