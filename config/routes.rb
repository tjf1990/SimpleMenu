SimpleMenu::Application.routes.draw do

  resources :food_tests

  resources :food_items

  devise_for :users

  post "versions/:id/revert" => 'versions#revert', :as => 'revert_version'

  root to: 'food_tests#index'
end
