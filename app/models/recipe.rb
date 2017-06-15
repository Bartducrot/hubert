class Recipe < ApplicationRecord
  has_many :user_recipes
  has_many :users, through: :user_recipes
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  mount_uploader :photo, RecipePhotoUploader
end
