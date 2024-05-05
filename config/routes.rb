Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
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

  #resources :recipes, only: [:index, :show, :new, :create, :destroy, :edit, :update]

end
