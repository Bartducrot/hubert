class CreateIngredientTastes < ActiveRecord::Migration[5.1]
  def change
    create_table :ingredient_tastes do |t|
      t.references :user, foreign_key: true
      t.references :ingredient, foreign_key: true
      t.boolean :like

      t.timestamps
    end
  end
end
