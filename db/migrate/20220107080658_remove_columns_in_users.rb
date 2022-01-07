class RemoveColumnsInUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :profile_image, :string
    remove_column :users, :home_image, :string
  end
end
