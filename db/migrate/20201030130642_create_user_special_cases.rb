class CreateUserSpecialCases < ActiveRecord::Migration[6.0]
  def change
    create_table :user_special_cases do |t|
      t.text :promotion_description
      t.references :special_case, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
