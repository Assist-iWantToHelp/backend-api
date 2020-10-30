class CreateNeeds < ActiveRecord::Migration[6.0]
  def change
    create_table :needs do |t|
      t.text :description
      t.boolean :deleted, default: false
      t.integer :state, default: 0
      t.text :contact_info
      t.string :contact_phone_number
      t.references :added_by, null: false
      t.references :chosen_by, null: true

      t.timestamps
    end

    add_foreign_key :needs, :users, column: :added_by_id
    add_foreign_key :needs, :users, column: :chosen_by_id
  end
end
