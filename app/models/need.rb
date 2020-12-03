class Need < ApplicationRecord
  enum status: { opened: 0, in_progress: 1, completed: 2, closed: 3 }
  enum category: { food: 0, drugs: 1, others: 2 }

  belongs_to :added_by, class_name: 'User'
  belongs_to :chosen_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true

  has_one :address, as: :addressable

  has_many :reviews

  validates :description, presence: true

  before_save :set_status_updates

  accepts_nested_attributes_for :address

  scope :opened, -> { where(status: statuses[:opened]) }
  scope :not_deleted, -> { where(deleted: false) }

  def person_name
    return "#{contact_first_name} #{contact_last_name}" if contact_first_name

    "#{added_by&.first_name} #{added_by&.last_name}"
  end

  def street_name
    address&.street_name || added_by.address&.street_name
  end

  private

  def set_status_updates
    self.updated_by ||= added_by
    self.status_updated_at ||= DateTime.current
  end
end
