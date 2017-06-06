class Recipe < ApplicationRecord
  has_many :users, through: :user_recipe
  has_many :ingredients, through: :recipe_ingredients
end
