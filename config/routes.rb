Rails.application.routes.draw do
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :user_recipes, only: [:create, :destroy]
  resources :users, only: [:show] do
    resources :user_recipes, only: [:index, :edit, :update]
    resources :shopping_items, only: [:update]
    resources :ingredient_tastes, only: [:create, :show]

  end
  resources :recipes, only: [:show]
  post :delete_user_recipe, to: "users#delete_user_recipe"
  post :update_people_recipe, to: "users#update_people_recipe"

  get "cookbook", to: "user_recipes#cookbook", as: "cookbook"
  get "calendar/:date", to: "user_recipes#index", as: 'calendar'
  get "/shopping_cart", to: "user_recipes#shopping_cart", as: 'shopping_cart'
  get "swiper", to: "ingredient_tastes#swiper", as: "swiper"
  get "ingredients", to: "ingredient_tastes#ingredients", as: "ingredients"

  post "/like", to: "ingredient_tastes#like_true"
  post "/dislike", to: "ingredient_tastes#like_false"

  # for the user settings not the swiper
  post "/like_it", to: "ingredient_tastes#like_true_and_reload"
  post "/dislike_it", to: "ingredient_tastes#like_false_and_reload"
end
