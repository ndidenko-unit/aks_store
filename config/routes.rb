Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :items
  resources :statuses
  resources :stores
  resources :trading_days do
    member do
      patch 'trade_item'
    end
  end
  root 'items#index'
end
