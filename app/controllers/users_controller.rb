class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
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
end
