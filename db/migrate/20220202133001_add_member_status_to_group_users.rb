class AddMemberStatusToGroupUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :group_users, :member_status, :integer, default: 0
    add_index :group_users, :member_status
  end
end
