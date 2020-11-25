class AddCategoryReferenceToNeeds < ActiveRecord::Migration[6.0]
  def change
    add_reference :needs, :category, foreign_key: true
  end
end
