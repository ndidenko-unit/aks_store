Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :items do
    member do
      get 'cancel_sale'
    end
  end

  delete '/expenses/:id', to: 'expenses#destroy', as: 'expense'
  # post 'expenses/add', to: 'expenses#add_expense', as: 'add_expense'


  resources :statuses
  resources :stores
  resources :trading_days do
    member do
      patch 'trade_item'
      post 'add_expense'
      get 'close_day'
    end
  end
  root 'items#index'
end
