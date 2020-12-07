class NotificationTemplate < ApplicationRecord
  with_options(presence: true, uniqueness: true) do
    validates :key, :template_id
  end
end
