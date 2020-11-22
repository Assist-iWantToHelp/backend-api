class AddExtraFieldsToNeeds < ActiveRecord::Migration[6.0]
  def change
    remove_column :needs, :contact_info, :text
    add_column :needs, :contact_first_name, :string
    add_column :needs, :contact_last_name, :string
    add_reference :needs, :address
  end
end
