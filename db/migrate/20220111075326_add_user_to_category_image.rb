class AddUserToCategoryImage < ActiveRecord::Migration[5.2]
  def change
    add_reference :category_images, :user, foreign_key: true
  end
end
