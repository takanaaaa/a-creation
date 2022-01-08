class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|

      t.references :visiter, foreign_key:{to_table: :users}
      t.references :visited, foreign_key:{to_table: :users}
      t.references :post, foreign_key: true
      t.references :post_comments, foreign_key: true
      t.string :action
      t.boolean :checked

      t.timestamps
    end
  end
end
