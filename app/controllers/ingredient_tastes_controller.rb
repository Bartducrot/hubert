class IngredientTastesController < ApplicationController

  before_action :set_ingredient_taste, only: [:update]

  def swiper
    @ingredients = current_user.unknown_ingredients
    # @ingredient_taste = IngredientTaste.new()
    # @ingredient_taste.user = current_user
    # @ingredient_taste.ingredient = @ingredients.pop
    @ingredient_objects = []
    @ingredients.each do |ingredient|
      @ingredient_objects << { category: ingredient.category, name: ingredient.name }
    end
  end

  def like_true
    # binding.pry
    # # raise
    ingredient_taste = IngredientTaste.create(user: current_user, ingredient_id: Ingredient.where(name: params['name']).first.id, like: true )
  end

  def like_false
    # binding.pry
    # raise
    ingredient_taste = IngredientTaste.create(user: current_user, ingredient_id: Ingredient.where(name: params['name']).first.id, like: false )
  end

  def index

  end

  private

  def set_ingredient_taste
    @ingredient_taste = IngredientTaste.find(param[:id])
  end
end
