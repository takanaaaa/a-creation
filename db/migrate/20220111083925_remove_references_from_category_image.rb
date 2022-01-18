class RemoveReferencesFromCategoryImage < ActiveRecord::Migration[5.2]
  def change
    remove_column :category_images, :references
  end
end
