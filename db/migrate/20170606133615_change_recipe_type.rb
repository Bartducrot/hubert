class ChangeRecipeType < ActiveRecord::Migration[5.1]
  def change
    rename_column :recipes, :type, :recipe_type
  end
end
