Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :recipes do
    resources :stamp_middles, only: [:create, :destroy]
    collection do
      get :copy_and_new
    end
  end

  resources :likes, only: [:index]

  resources :recipes, only: [:index, :show, :new, :create, :destroy, :edit, :update]

end
