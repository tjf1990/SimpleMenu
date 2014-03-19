SimpleMenu::Application.routes.draw do

  resources :food_tests


  resources :food_items


  devise_for :users

  root to: 'food_tests#index'
end
