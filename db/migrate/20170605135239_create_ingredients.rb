class CreateIngredients < ActiveRecord::Migration[5.1]
  def change
    create_table :ingredients do |t|
      t.string :category
      t.string :name
      t.date :start_of_seasonality
      t.date :end_of_seasonality

      t.timestamps
    end
  end
end
