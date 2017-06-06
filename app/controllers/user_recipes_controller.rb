class UserRecipesController < ApplicationController

  def cookbook
    @user_recipes = UserRecipe.where(:user_id == current_user.id)
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
