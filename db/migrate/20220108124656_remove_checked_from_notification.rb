class RemoveCheckedFromNotification < ActiveRecord::Migration[5.2]
  def change
    remove_column :notifications, :checked, :boolean
  end
end
