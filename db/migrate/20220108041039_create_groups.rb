class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      
      t.references :category, foreign_key: true
      t.string :name
      t.text :introduction
      
      t.timestamps
    end
  end
end
