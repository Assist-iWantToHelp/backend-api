class Need < ApplicationRecord
  belongs_to :added_by, class_name: 'User'
  belongs_to :chosen_by, class_name: 'User', optional: true

  validates :description, presence: true
  validates :added_by, presence: true

  enum status: %i[opened in_progres completed closed]
end
