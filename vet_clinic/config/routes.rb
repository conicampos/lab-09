Rails.application.routes.draw do
  # Indica que la página principal es el index de pets
  root to: "pets#index"
  
  devise_for :users
  
  resources :pets
  resources :owners
  resources :vets
  resources :appointments
  resources :treatments
end