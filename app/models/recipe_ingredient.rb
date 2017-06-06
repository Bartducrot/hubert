class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient
  has_many :shopping_items
end
