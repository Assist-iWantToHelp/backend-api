class AddPolymorphicAssociationOnAddresses < ActiveRecord::Migration[6.0]
  def up
    add_column :addresses, :addressable_id, :bigint
    add_column :addresses, :addressable_type, :string
    add_index :addresses, [:addressable_type, :addressable_id]

    Address.update_all(addressable_type: 'User')
    Address.find_each do |address|
      address.update!(addressable_id: address.user_id)
    end

    remove_column :addresses, :user_id
  end

  def down
    add_column :addresses, :user_id, :bigint

    Address.find_each do |address|
      address.update!(user_id: address.addressable_id)
    end

    remove_index :addresses, [:addressable_type, :addressable_id]
    remove_column :addresses, :addressable_type
    remove_column :addresses, :addressable_id
  end
end
