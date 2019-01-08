Rails.application.routes.draw do
  devise_for :users
  get 'admin', action: :admin, controller: 'users'
  post 'admin', action: :change_role, controller: 'users'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :items do
    member do
      get 'cancel_sale'
    end
  end

  delete '/expenses/:id', to: 'expenses#destroy', as: 'expense'

  resources :statuses
  resources :stores
  resources :trading_days do
    member do
      patch 'trade_item'
      post 'add_expense'
      get 'close_day'
      get 'unblock_day'
    end
  end
  root 'items#index'
end
