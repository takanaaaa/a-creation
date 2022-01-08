class AddCheckedToNotification < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :checked, :boolean, default: false, null: false
  end
end
