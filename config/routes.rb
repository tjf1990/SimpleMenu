SimpleMenu::Application.routes.draw do

  resources :food_tests

  resources :food_items

  devise_for :users

  post ":controller/:id" => ":controller#update" #workaround for UJS form_for not working with PUT requests
  post "versions/:id/revert" => 'versions#revert', :as => 'revert_version'

  root to: 'food_tests#index'
end
