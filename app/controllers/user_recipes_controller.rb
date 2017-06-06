class UserRecipesController < ApplicationController
  def cookbook
    @user_recipes = UserRecipe.where(:user_id == current_user.id)
  end
end
