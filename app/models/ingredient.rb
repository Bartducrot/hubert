class Ingredient < ApplicationRecord
  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients
  has_many :ingredient_tastes
  has_many :users, through: :ingredient_tastes
end
