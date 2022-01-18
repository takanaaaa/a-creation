class RemoveMessageFromMessage < ActiveRecord::Migration[5.2]
  def change
    remove_column :messages, :message, :text
  end
end
