class Ingredient < ApplicationRecord
  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients
  has_many :ingredient_tastes
  has_many :users, through: :ingredient_tastes

  include PgSearch
    pg_search_scope :search_by_name_and_category,
      against: [ :name, :category ]
end
