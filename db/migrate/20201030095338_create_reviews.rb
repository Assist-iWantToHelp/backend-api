class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.integer :stars
      t.text :comment
      t.references :provided_by, null: false
      t.references :given_to, null: false
      t.references :need, null: false, foreign_key: true

      t.timestamps
    end

    add_foreign_key :reviews, :users, column: :provided_by_id
    add_foreign_key :reviews, :users, column: :given_to_id
  end
end
