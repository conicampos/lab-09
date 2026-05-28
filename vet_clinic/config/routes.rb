Rails.application.routes.draw do
  root to: "home#index"
  
  devise_for :users, skip: [:registrations]
  
  resources :pets
  resources :owners
  resources :vets
  resources :appointments do
    resources :treatments, except: [:index, :show]
  end
end
