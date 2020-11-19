class Need < ApplicationRecord
  enum status: { opened: 0, in_progress: 1, completed: 2, closed: 3 }

  belongs_to :added_by, class_name: 'User'
  belongs_to :chosen_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User'

  has_many :reviews

  validates :description, presence: true

  scope :opened, -> { where(status: statuses[:opened]) }
end
