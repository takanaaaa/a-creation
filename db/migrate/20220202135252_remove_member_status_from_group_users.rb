class RemoveMemberStatusFromGroupUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :group_users, :member_status, :integer
  end
end
