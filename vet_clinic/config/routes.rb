Rails.application.routes.draw do
  
  resources :owners
  resources :pets
  resources :vets
  resources :appointments do
    resources :treatments, except: [:index, :show]
  end

  root "owners#index" 
end