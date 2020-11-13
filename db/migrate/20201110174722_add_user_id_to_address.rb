class AddUserIdToAddress < ActiveRecord::Migration[6.0]
  def up
    add_reference :addresses, :user

    User.find_each do |user|
      address = Address.find_by(id: user.address_id)
      address.update!(user_id: user.id) if address
    end
  end

  def down
    Address.find_each do |address|
      user = User.find_by(id: address.user_id)
      user.update!(address_id: address.id) if user
    end

    remove_reference :addresses, :user
  end
end
