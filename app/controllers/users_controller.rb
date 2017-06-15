class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @liked_ingredient_tastes = @user.ingredient_tastes.where(like: true)
    @disliked_ingredient_tastes = @user.ingredient_tastes.where(like: false)
  end



  def delete_user_recipe
    user_recipe = UserRecipe.where(user: current_user, date: params[:date], recipe_id: params[:recipe_id]).first
    user_recipe.destroy if user_recipe
      respond_to do |format|
        format.js { head :ok }
      end
  end
end
