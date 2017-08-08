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
    # binding.pry
    # # raise
    ingredient_taste = IngredientTaste.create(user: current_user, ingredient_id: Ingredient.where(name: params['name']).first.id, like: true )
  end

  def like_true_and_reload
    @user = current_user
    @ingredient = Ingredient.where(name: params['name']).first

    ingredient_taste = IngredientTaste.where(user: current_user, ingredient_id: @ingredient.id).first
    if ingredient_taste
      ingredient_taste.like = true
      ingredient_taste.save
    else
      IngredientTaste.create(user: current_user, ingredient_id: Ingredient.where(name: params['name']).first.id, like: true )
    end
  end

  def like_false
    # binding.pry
    # raise
    ingredient_taste = IngredientTaste.create(user: current_user, ingredient_id: Ingredient.where(name: params['name']).first.id, like: false )
  end

  def like_false_and_reload
    @user = current_user
    @ingredient = Ingredient.where(name: params['name']).first

    puts "************************************"
    puts "************************************"
    puts "************************************"
    puts "************************************"
    p @ingredient


    ingredient_taste = IngredientTaste.where(user: current_user, ingredient_id: @ingredient.id).first
    if ingredient_taste
      ingredient_taste.like = false
      ingredient_taste.save
    else
      IngredientTaste.create(user: current_user, ingredient_id: Ingredient.where(name: params['name']).first.id, like: false )
    end
  end



  def index

  end

  private

  def set_ingredient_taste
    @ingredient_taste = IngredientTaste.find(param[:id])
  end
end
