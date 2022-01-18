class RemoveVisiterIdFromNotification < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :notifications, :users
    remove_index :notifications, :visiter_id
    remove_reference :notifications, :visiter
  end
end
