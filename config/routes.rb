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
      patch 'trade_item_without_code'
      post 'add_expense'
      post 'change_seller'
      get 'close_day'
      get 'unblock_day'
    end
  end
  root 'items#index'
end
