class IngredientTastesController < ApplicationController

  before_action :set_ingredient_taste, only: [:update]

  def swiper
    @ingredient_objects = current_user.unknown_ingredients.map do |ingredient|
      { id: ingredient.id, category: ingredient.category, name: ingredient.name }
    end
  end

  def ingredients
    @user = current_user
    if params["info"].present?
      @ingredients = Ingredient.search_by_name_and_category(params["info"])
    else
      @ingredients = Ingredient.all
    end

    @tastes = current_user.ingredient_tastes
  end

  def like_true
    IngredientTaste.create!(
      user: current_user,
      ingredient: Ingredient.find(params[:id]),
      like: true
    )
  end

  def like_true_and_reload
    @user = current_user
    @ingredient = Ingredient.where(name: params['name']).first

    ingredient_taste = IngredientTaste.where(
      user: current_user,
      ingredient_id: @ingredient.id
    ).first

    if ingredient_taste
      ingredient_taste.like = true
      ingredient_taste.save
    else
      IngredientTaste.create(
        user: current_user,
        ingredient: Ingredient.find_by(name: params['name']),
        like: true
      )
    end
  end

  def like_false
    IngredientTaste.create!(
      user: current_user,
      ingredient: Ingredient.find(params[:id]),
      like: false
    )
  end

  def like_false_and_reload
    @user = current_user
    @ingredient = Ingredient.find_by(name: params['name'])

    ingredient_taste = IngredientTaste.where(user: current_user, ingredient_id: @ingredient.id).first
    if ingredient_taste
      ingredient_taste.like = false
      ingredient_taste.save
    else
      IngredientTaste.create(
        user: current_user,
        ingredient: Ingredient.find_by(name: params['name']),
        like: false
      )
    end
  end

  def index
  end

  private

  def set_ingredient_taste
    @ingredient_taste = IngredientTaste.find(param[:id])
  end
end
