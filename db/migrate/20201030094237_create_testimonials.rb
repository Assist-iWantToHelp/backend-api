class CreateTestimonials < ActiveRecord::Migration[6.0]
  def change
    create_table :testimonials do |t|
      t.text :message
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
