class AddColumnsNeedStatus < ActiveRecord::Migration[6.0]
  def change
    add_column :needs, :status_updated_at, :datetime
    add_reference :needs, :updated_by
    add_foreign_key :needs, :users, column: :updated_by_id
  end
end
