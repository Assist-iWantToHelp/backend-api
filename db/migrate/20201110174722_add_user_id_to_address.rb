class AddUserIdToAddress < ActiveRecord::Migration[6.0]
  def up
    add_reference :addresses, :user

    Address.find_each do |address|
      address.update(user_id: address.user.id)
    end
  end

  def down
    User.find_each do |user|
      user.update(address_id: user.address.id)
    end

    remove_reference :addresses, :user
  end
end
