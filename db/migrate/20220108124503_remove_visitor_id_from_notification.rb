class RemoveVisitorIdFromNotification < ActiveRecord::Migration[5.2]
  def change
    remove_column :notifications, :visitor_id, :integer
  end
end
