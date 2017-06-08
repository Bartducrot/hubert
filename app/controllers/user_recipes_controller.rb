class UserRecipesController < ApplicationController

  def cookbook
    @user_recipes = UserRecipe.where(:user_id == current_user.id)
  end

  def shopping_cart
    @user_recipes = UserRecipe.where(:user_id == current_user.id)
    @shopping_items = []
    @user_recipes.each do |recipe|
      if recipe.date >= Date.today
        recipe.shopping_items.each do |item|
          @shopping_items << item
        end
      end
    end
    @recipe_ingredients = []
    @ingredients = []
    @shopping_items.each do |item|
      @recipe_ingredients << RecipeIngredient.find(item.recipe_ingredient_id)
      @ingredients << Ingredient.find(item.recipe_ingredient.ingredient_id)
    end
    @ingredients_hash = {}
    @recipe_ingredients.each do |r_ingredient|
      unless @ingredients_hash.has_key?(r_ingredient.ingredient.category)
        @ingredients_hash[r_ingredient.ingredient.category] = []
      end
      @ingredients_hash[r_ingredient.ingredient.category] << [r_ingredient.ingredient.name, r_ingredient.quantity, r_ingredient.ingredient.unit]
    end
  end






  def index
    @day = Date.parse(params[:date])
    @user_recipe = UserRecipe.new
    if params[:date].present?
      @user_recipes = UserRecipe.where(date: params[:date]).where(user: current_user)
    else
      @user_recipes = UserRecipe.where(date: Date.today).where(user: current_user)
    end
  end

  def create
    @user_recipe = UserRecipe.new(user_recipe_params)
    @user_recipe.user = current_user
    @user_recipe.save
    @shopping_items = []
    @user_recipe.recipe.recipe_ingredients.each do |recipe_ingredient|
      @shopping_items << ShoppingItem.create!(bought: false, quantity: (recipe_ingredient.quantity * @user_recipe.number_of_people),  recipe_ingredient_id: recipe_ingredient.id, user_recipe_id: @user_recipe.id)
    end
    # redirect_to user_user_recipes_path(current_user)
    redirect_to calendar_path(user_recipe_params[:date])
  end

  def edit
  end

  def update
  end

  def date

  end

  private

  def user_recipe_params
    params.require(:user_recipe).permit(:number_of_people, :recipe_id, :date)
  end

end
