Rails.application.routes.draw do
  resources :recipes do
  end

  resources :recipes, only: [:index, :show, :new, :create, :destroy, :edit, :update]

end
