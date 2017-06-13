class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]
  has_many :user_recipes
  has_many :recipes, through: :user_recipes
  has_many :shopping_items, through: :user_recipes
  has_many :ingredient_tastes
  has_many :ingredients, through: :ingredient_tastes


  def known_ingredients
    @ingredients = Ingredient.joins(:ingredient_tastes).where(ingredient_tastes: {user: self})
  end

  def unknown_ingredients
    @known_ingredients = known_ingredients
    @ingredients = Ingredient.all - known_ingredients
  end

  def selected_recipe(category, date)
    selected_user_recipe = self.user_recipes.where(date: date).select{|ur| ur.recipe.category == category}.first
    if selected_user_recipe
      return selected_user_recipe.recipe
    else
      return false
    end
  end

  def liked_recipes(category)
    liked_ingredients_ids = Ingredient.all.select{ |ingredient| ingredient.ingredient_tastes.where(user: self).where(like: false).blank? }.map(&:id)
    # RecipeIngredient.where(ingredient_id: ingredients_ids)
    @recipes = Recipe.where(category: category)
    user_liked_recipes = []

    @recipes.each do |recipe|
      recipe_ingredients_ids = []
      recipe.recipe_ingredients.each do |ri|
        recipe_ingredients_ids << ri.ingredient_id
      end
      user_liked_recipes << recipe if (recipe_ingredients_ids - liked_ingredients_ids).empty?
    end
    return user_liked_recipes
  end




  def self.find_for_facebook_oauth(auth)
    user_params = auth.slice(:provider, :uid)
    user_params.merge! auth.info.slice(:email, :first_name, :last_name)
    user_params[:facebook_picture_url] = auth.info.image
    user_params[:token] = auth.credentials.token
    user_params[:token_expiry] = Time.at(auth.credentials.expires_at)
    user_params = user_params.to_h

    user = User.find_by(provider: auth.provider, uid: auth.uid)
    user ||= User.find_by(email: auth.info.email) # User did a regular sign up in the past.
    if user
      user.update(user_params)
    else
      user = User.new(user_params)
      user.password = Devise.friendly_token[0,20]  # Fake password for validation
      user.save
    end

    return user
  end

end
