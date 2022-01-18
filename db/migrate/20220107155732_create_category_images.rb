class CreateCategoryImages < ActiveRecord::Migration[5.2]
  def change
    create_table :category_images do |t|
      
      t.references :category, foreign_key: true
      t.string :image_id

      t.timestamps
    end
  end
end
