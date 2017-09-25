class UserRecipesController < ApplicationController

  def cookbook
    @user_recipes = UserRecipe.where(user_id: current_user.id)
    @next_user_recipes = UserRecipe.where(user_id: current_user.id).where("date >= ?", Date.today).order(updated_at: :desc)
  end

  def shopping_cart
    @user_recipes = UserRecipe.where(user_id: current_user.id)

    @shopping_items = []
    @user_recipes.each do |u_recipe|
      if u_recipe.date >= Date.today
        u_recipe.shopping_items.each do |item|
          @shopping_items << item
        end
      end
    end


    @ingredients_hash = {}

    @shopping_items.each do |shopping_item|
      unless @ingredients_hash.has_key?(shopping_item.recipe_ingredient.ingredient.category)
        @ingredients_hash[shopping_item.recipe_ingredient.ingredient.category] = []
      end
      h = {s_item: shopping_item ,
        name: shopping_item.recipe_ingredient.ingredient.name,
        unit: shopping_item.recipe_ingredient.unit,
        recipe_name: shopping_item.recipe_ingredient.recipe.name,
        date: shopping_item.user_recipe.date.strftime('%A %d %B %Y')
      }
      @ingredients_hash[shopping_item.recipe_ingredient.ingredient.category] << h
    end

    @sorted_ingredient_hash = {}
    @ingredients_hash.each do |category, array|
      @sorted_ingredient_hash[category] = array.sort_by{ |hsh| hsh[:name] }
      puts @sorted_ingredient_hash[category]
    end
    @sorted_ingredient_category_hash = @sorted_ingredient_hash.sort.to_h
    puts @sorted_ingredient_category_hash
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
    # find the selected recipe
    @recipe = Recipe.find(params[:user_recipe][:recipe_id])
    # destroy the previuous UserRecipe instance for this date
    UserRecipe.where(user: current_user, date: params[:user_recipe][:date]).select{|ur| ur.recipe.category == @recipe.category}.each{|ur| ur.destroy}
    # create a new UserRecipe instance from the params
    @user_recipe = UserRecipe.new(user_recipe_params)
    @user_recipe.user = current_user
    @user_recipe.save
    @shopping_items = []
    @user_recipe.recipe.recipe_ingredients.each do |recipe_ingredient|
      new_item = ShoppingItem.new()
      new_item.bought = false
      # each recipe is for  people => a 5 people recipe take 5 times the quantity
      new_item.quantity = recipe_ingredient.quantity * @user_recipe.number_of_people
      new_item.recipe_ingredient = recipe_ingredient
      new_item.user_recipe = @user_recipe
      new_item.save!
      @shopping_items << new_item
    end

    # redirect_to user_user_recipes_path(current_user)
    # redirect_to calendar_path(user_recipe_params[:date])
    # - ajax doesn't redirect
  end

  def edit
  end

  def update

  end

  def date

  end

  def destroy
    user_recipe = UserRecipe.find(params[:id])
    user_recipe.destroy
  end

  private

  def user_recipe_params
    params.require(:user_recipe).permit(:number_of_people, :recipe_id, :date)
  end

end
