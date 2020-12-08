class Questionnaire < ApplicationRecord
  belongs_to :user

  validates :answear_1, presence: true
  validates :answear_2, presence: true
  validates :answear_3, presence: true
  validates :answear_4, presence: true
  validates :answear_5, presence: true
end
