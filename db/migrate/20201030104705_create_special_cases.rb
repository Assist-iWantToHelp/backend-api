class CreateSpecialCases < ActiveRecord::Migration[6.0]
  def change
    create_table :special_cases do |t|
      t.text :description
      t.boolean :validated, default: false
      t.boolean :deleted, default: false
      t.integer :status, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
