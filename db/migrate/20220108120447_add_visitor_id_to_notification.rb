class AddVisitorIdToNotification < ActiveRecord::Migration[5.2]
  def change
    add_reference :notifications, :visitor, foreign_key:{to_table: :users}
  end
end
