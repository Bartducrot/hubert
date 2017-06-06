class CreateShoppingItems < ActiveRecord::Migration[5.1]
  def change
    create_table :shopping_items do |t|
      t.boolean :bought
      t.integer :quantity
      t.references :recipe_ingredient, foreign_key: true
      t.references :user_recipe, foreign_key: true

      t.timestamps
    end
  end
end
