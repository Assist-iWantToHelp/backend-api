class AddColumnsNeedStatus < ActiveRecord::Migration[6.0]
  def change
    add_column :needs, :status_updated_at, :datetime
    add_reference :needs, :user, null: false, foreign_key: true
  end
end
