class ChangeShoppinItemQuantityFromIntegerToFloat < ActiveRecord::Migration[5.1]
  def change
    change_column :shopping_items, :quantity, :float
  end
end
