Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  resources :users, only: [:show] do
    resources :user_recipes, only: [:new, :create, :edit, :update] do
      resources :recipes, only: [:show]
    end
    resources :shopping_items, only: [:update]
  end

get "cookbook", to: "user_recipes#cookbook", as: "cookbook"


end
