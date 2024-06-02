Rails.application.routes.draw do
  get 'pages/home'
  devise_for :users, controllers: {
    registrations: 'users/registrations',

    sessions: 'users/sessions',
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  resources :users, only: [:show]
  
  resources :recipes do
    resources :stamp_middles, only: [:create, :destroy]
    resources :comments, only: [:index, :create, :destroy, :update]
    collection do
      get :copy_and_new
      get :evolution
    end
  end

  post '/path_to_your_action', to: 'recipes#ask_open_ai'

  resources :likes, only: [:index]
  resources :ranking, only: [:index]

  root 'pages#home'

  get 'privacy_policy', to: 'pages#privacy_policy'
  get 'contact', to: 'pages#contact'

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'

    resources :recipes do
      resources :comments, only: [:index,:destroy]
    end

    resources :users
  end

end
