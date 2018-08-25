class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @liked_ingredient_tastes =  @user.ingredient_tastes.where(like: true).joins(:ingredient).order('ingredients.name ASC')
    @disliked_ingredient_tastes = @user.ingredient_tastes.where(like: false).joins(:ingredient).order('ingredients.name ASC')
  end

  def delete_user_recipe
    user_recipe = UserRecipe.find_by(user: current_user, date: params[:date], recipe_id: params[:recipe_id])
    user_recipe.destroy if user_recipe
    respond_to do |format|
      format.js { head :ok }
    end
  end

  def update_people_recipe
    user_recipe = UserRecipe.where(
      user: current_user,
      date: params[:date],
      recipe_id: params[:recipe_id]
    ).first_or_create

    user_recipe.update(
      number_of_people: params[:number_of_people]
    )

    user_recipe.reload.shopping_items.each do |shoppping_item|
      shoppping_item.update(
        quantity: shoppping_item.recipe_ingredient.quantity * user_recipe.number_of_people
      )
    end
    respond_to do |format|
      format.js { head :ok }
    end
  end

  def set_user_to_vegetarian
    like_on_category("meat", false) # dislike all the Ingredient from the "meat" category
    like_on_category("fish", false)
    like_on_category("seafood", false)
    redirect_to user_path(current_user.id)
  end

  def set_user_to_vegan
    set_user_to_vegetarian
    like_on_category("dairy", false)
    # dislike all egg recipes
    Ingredient.where("name LIKE ?", "%egg %").each do |egg_ingredient|
      taste = IngredientTaste.find_by(
        user: current_user,
        ingredient: egg_ingredient
      )
      # check if there is already a define taste on it, puts it to false
      if taste
        taste.update(like: false)
      else
        # if no taste is define for this ingredient, create it and puts the value of "like" to true or false (parameter)
        IngredientTaste.create(
          user: current_user,
          ingredient: egg_ingredient,
          like: false
        )
      end
    end
  end

# ALL THE Ingredients Categories :
# vegetable
# dairy
# meat
# baking
# seasonings
# spices
# fish
# sauces
# sweeteners
# condiments
# beverages
# alternatives
# oils
# fruits
# nuts
# alcohol
# desserts
# seafood
# soup

  private

  def like_on_category(category_name, like) #category_name is a string, like is a boolean (put false for dislike)
    # Iterate one each Ingredient with category_name category
    user = current_user
    Ingredient.where(category: category_name).each do |ingr|
      taste = IngredientTaste.find_by(user: user, ingredient: ingr)
      # check if there is already a define taste on it, puts it to false
      if taste
        taste.like = like
        taste.save
        puts "as #{ingr.name} is in the #{category_name} category, #{user.first_name} don't like this anymore"
      else
        # if no taste is define for this ingredient, create it and puts the value of "like" to true or false (parameter)
        taste = IngredientTaste.create(user: user, ingredient: ingr, like: like)
        puts "as #{ingr.name} is in the #{category_name} category, #{user.first_name} don't like this"
      end
    end
  end
end
