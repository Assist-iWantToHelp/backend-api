class CreateQuestionnaires < ActiveRecord::Migration[6.0]
  def change
    create_table :questionnaires do |t|
      t.text :answear_1
      t.text :answear_2
      t.text :answear_3
      t.text :answear_4
      t.text :answear_5
      t.text :total
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
