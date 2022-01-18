class RemoveVisiterIdFromNotification < ActiveRecord::Migration[5.2]
  def change
    remove_reference :notifications, :visiter_id, foreign_key:{to_table: :users}
  end
end
