class AddStatusToGroupUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :group_users, :status, :integer, default: 0
    add_index :group_users, :status
  end
end
