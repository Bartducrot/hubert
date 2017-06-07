Rails.application.routes.draw do
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  resources :users, only: [:show] do
    resources :user_recipes, only: [:index, :create, :edit, :update]
    resources :shopping_items, only: [:update]
  end
  resources :recipes, only: [:show]


  get "cookbook", to: "user_recipes#cookbook", as: "cookbook"
  get "calendar/:date", to: "user_recipes#index", as: 'calendar'
  get "/shopping_cart", to: "pages#shopping_cart"



end
