Rails.application.routes.draw do
  devise_for :users
  resources :recipes do
  end


  resources :recipes, only: [:index, :show, :new, :create, :destroy, :edit, :update]

end
