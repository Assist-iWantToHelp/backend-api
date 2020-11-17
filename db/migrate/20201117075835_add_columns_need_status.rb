class AddColumnsNeedStatus < ActiveRecord::Migration[6.0]
  def change
    add_column :needs, :status_updated_at, :datetime
    add_column :needs, :updated_by, :integer
  end
end
