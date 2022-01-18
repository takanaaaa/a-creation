class RemoveVisiterIdIdFromNotifications < ActiveRecord::Migration[5.2]
  def change
    remove_column :notifications, :visiter_id_id, :integer
  end
end
