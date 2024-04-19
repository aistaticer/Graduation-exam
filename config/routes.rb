Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :recipes do
    resources :stamp_middles, only: [:create, :destroy]
  end

  resources :likes, only: [:index]

  resources :recipes, only: [:index, :show, :new, :create, :destroy, :edit, :update]

end
