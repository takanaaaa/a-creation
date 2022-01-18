class RemoveVisiterIdIdFromNotifications < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :notifications, :users
    remove_index :notifications, :visiter_id_id
    remove_column :notifications, :visiter_id_id, :integer
  end
end
