class AddUnitToIngredients < ActiveRecord::Migration[5.1]
  def change
    add_column :ingredients, :unit, :string
  end
end
