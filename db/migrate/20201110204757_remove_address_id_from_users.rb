class RemoveAddressIdFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :address_id, :bigint
  end
end
