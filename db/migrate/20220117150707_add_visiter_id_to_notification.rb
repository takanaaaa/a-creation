class AddVisiterIdToNotification < ActiveRecord::Migration[5.2]
  def change
    add_reference :notifications, :visiter, foreign_key:{to_table: :users}
  end
end
