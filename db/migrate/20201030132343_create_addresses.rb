class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.string :street_name
      t.string :city
      t.text :details
      t.string :postal_code
      t.string :coordinates

      t.timestamps
    end
  end
end
