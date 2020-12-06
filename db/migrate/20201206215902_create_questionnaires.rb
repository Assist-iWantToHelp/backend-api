class CreateQuestionnaires < ActiveRecord::Migration[6.0]
  def change
    create_table :questionnaires do |t|
      t.string :answear_1
      t.string :answear_2
      t.string :answear_3
      t.string :answear_4
      t.string :answear_5
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
