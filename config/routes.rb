Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  resources :users, only: [:show] do
    resources :user_recipes, only: [:index, :create, :edit, :update] do
      resources :recipes, only: [:show]
    end
    resources :shopping_items, only: [:edit, :update]
  end

  get "calendar/:date", to: "user_recipes#index", as: 'calendar'

end
