class UserRecipe < ApplicationRecord
  belongs_to :recipe
  belongs_to :user
  has_many :shopping_items, dependent: :destroy
end
