class ShoppingItem < ApplicationRecord
  belongs_to :recipe_ingredient
  belongs_to :user_recipe
end
