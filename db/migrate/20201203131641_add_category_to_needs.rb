class AddCategoryToNeeds < ActiveRecord::Migration[6.0]
  def change
    add_column :needs, :category, :integer
  end
end
