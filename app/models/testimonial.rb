class Testimonial < ApplicationRecord
  belongs_to :user

  validates :message, presence: true
end
