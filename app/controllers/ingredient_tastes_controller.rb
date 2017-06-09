class IngredientTastesController < ApplicationController

  def create

    @ingredient
    @ingredient_taste = IngredientTaste.new()
    @ingredient_taste.user = current_user
    @ingredient_taste.ingredient =
  end

  def update
    @ingredient = Ingredient.where(:ingredient_taste == @ingredient_taste).find_by(:user == current_user)

  end

  def index

  end

  private

  def set_ingredient_taste
    @ingredient_taste = IngredientTaste.find(param[:id])
  end
end
