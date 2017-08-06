class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @liked_ingredient_tastes = @user.ingredient_tastes.where(like: true).sort_by { |i| i.ingredient.name }
    @disliked_ingredient_tastes = @user.ingredient_tastes.where(like: false).sort_by { |i| i.ingredient.name }
  end

  def delete_user_recipe
    user_recipe = UserRecipe.where(user: current_user, date: params[:date], recipe_id: params[:recipe_id]).first
    user_recipe.destroy if user_recipe
      respond_to do |format|
        format.js { head :ok }
      end
  end

  def update_people_recipe
    user_recipe = UserRecipe.where(user: current_user, date: params[:date],recipe_id: params[:recipe_id]).first
    user_recipe.update(number_of_people: params[:number_of_people])
    puts "debug"
      respond_to do |format|
        format.js { head :ok }
      end
  end

  def set_user_to_vegetarian
    # take the current user
    user = current_user
    # Iterate one each Ingredient with meat category
    Ingredient.all.where(category: "meat").each do |ingr|
      taste = IngredientTaste.find_by(user: user, ingredient: ingr)
      # check if there is already a define taste on it, puts it to false
      if taste
        taste.like = false
        taste.save
        puts "as #{ingr.name} is in the meat category, the vegetarian don't like this => #{user.first_name} don't like this anymore"
      else
        # if no taste is define for this ingredient, create it and puts "false" as the value for "like"
        taste = IngredientTaste.create(user: user, ingredient: ingr, like: false)
        puts "as #{ingr.name} is in the meat category, the vegetarian don't like this => #{user.first_name} don't like this"
      end
    end
  end
end
