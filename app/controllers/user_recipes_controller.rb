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

    # -------------------------------------------------------------------
    # -----------------------------------------------------------------

    @ingredients_hash = {}

    @shopping_items.each do |shopping_item|
      unless @ingredients_hash.has_key?(shopping_item.recipe_ingredient.ingredient.category)
        @ingredients_hash[shopping_item.recipe_ingredient.ingredient.category] = []
      end
      h = {
        s_item: shopping_item ,
        name: shopping_item.recipe_ingredient.ingredient.name,
        unit: shopping_item.recipe_ingredient.unit,
        recipe_name: shopping_item.recipe_ingredient.recipe.name,
        date: shopping_item.user_recipe.date.strftime('%A %d %B %Y')
      }
      @ingredients_hash[shopping_item.recipe_ingredient.ingredient.category] << h
    end
    # @ingredient_hash is an hash of array of hash, with category as key
    @sorted_ingredient_hash = {}
    @ingredients_hash.each do |category, array|
      @sorted_ingredient_hash[category] = array.sort_by{ |hsh| hsh[:name] }
    end

    # => @sorted_ingredient_hash =
    # {"category_name1" =>
    #           [
    #             {:s_item => ShoppingItem1, :name => "string" , :unit => "unit_name", :recipe_name => "string", :date => "string"},
    #             {:s_item => ShoppingItem2, :name => "string" , :unit => "unit_name", :recipe_name => "string", :date => "string"}
    #           ]
    # "category_name2" =>
    #           [
    #             {:s_item => ShoppingItem3, :name => "string" , :unit => "unit_name", :recipe_name => "string", :date => "string"},
    #             {:s_item => ShoppingItem4, :name => "string" , :unit => "unit_name", :recipe_name => "string", :date => "string"}
    #           ]
    #  }
    #

    @ingredients_hash2 = {}
    @shopping_items.each do |shopping_item|
      # extracting the name and the category from the shopping item
      cat = shopping_item.recipe_ingredient.ingredient.category
      ingr_name = shopping_item.recipe_ingredient.ingredient.name

      # testing if the category of ingredient is already a key for the 1st layer of the hash
      unless @ingredients_hash2.has_key?(cat)
        @ingredients_hash2[shopping_item.recipe_ingredient.ingredient.category] = {}
      end
      puts ""
      puts "##############################################################"
      puts "check the category #{cat.upcase} BEFORE adding the ingredient #{ingr_name.upcase}"
      puts "number of ingredient in the category: #{@ingredients_hash2[cat].length}"
      puts "##############################################################"
      puts @ingredients_hash2[cat]
      # testing if he ingredient_name is already a key of the 2nd layer of the hash
      puts "###############################"
      puts "check the ingredient #{ingr_name} in the #{cat} category"
      puts "###############################"
      if @ingredients_hash2[cat].has_key?(ingr_name)
        @ingredients_hash2[cat][ingr_name] < shopping_item
        p @ingredients_hash2[cat][ingr_name]
      else
        # if the ingredient name is not a key yet, we create the array and put the s_item inside
        @ingredients_hash2[cat][ingr_name] = [shopping_item]
        p @ingredients_hash2[cat][ingr_name]
      end
      puts "##############################################################"
      puts "check the category #{cat.upcase} AFTER adding the ingredient #{ingr_name.upcase}"
      puts "number of ingredient in the category: #{@ingredients_hash2[cat].length}"
      puts "##############################################################"
      puts @ingredients_hash2[cat]
      puts "NEXT NEXT NEXT NEXT NEXT NEXT NEXT NEXT NEXT NEXT NEXT NEXT "
      puts ""
    end






    #  OBJECTIF
    # => @sorted_ingredient_hash =
    # {"category_name1" =>
    #           {
    #             "ingredient_name1" => [ShoppingItem1, ShoppingItem2],
    #             "ingredient_name2" => [ShoppingItem3, ShoppingItem4]
    #           }
    # {"category_name2" =>
    #           {
    #             "ingredient_name3" => [ShoppingItem5, ShoppingItem6],
    #             "ingredient_name4" => [ShoppingItem7, ShoppingItem8]
    #           }
    #  }

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
