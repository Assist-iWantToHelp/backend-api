class Need < ApplicationRecord
  belongs_to :user

  validates :description, presence: true
  validates :added_by, presence: true

  enum status: %i[opened in_progres completed closed]
end
