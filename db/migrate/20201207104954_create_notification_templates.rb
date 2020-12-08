class CreateNotificationTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :notification_templates do |t|
      t.string :key, null: false, index: { unique: true }
      t.string :template_id, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
