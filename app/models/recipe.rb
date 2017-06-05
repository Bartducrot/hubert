class Recipe < ApplicationRecord
  has_many :users, through: :user_recipe
end
