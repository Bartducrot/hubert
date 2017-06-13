class RemoveQuantityFromRecipeIngredients < ActiveRecord::Migration[5.1]
  def change
     remove_column :recipe_ingredients, :quantity, :integer
  end
end
