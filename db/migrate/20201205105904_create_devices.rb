class CreateDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :devices do |t|
      t.string :signal_id, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
