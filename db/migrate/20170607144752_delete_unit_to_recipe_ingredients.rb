class DeleteUnitToRecipeIngredients < ActiveRecord::Migration[5.1]
  def change
    remove_column :recipe_ingredients, :unit, :string
  end
end
