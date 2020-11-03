class Review < ApplicationRecord
  belongs_to :provided_by, class_name: 'User'
  belongs_to :given_to, class_name: 'User'

  belongs_to :need, class_name: 'Need'

  validates :stars, presence: true, inclusion: { in: 1..5 }
end
