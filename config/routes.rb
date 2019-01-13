Rails.application.routes.draw do
  devise_for :users
  get 'admin', action: :admin, controller: 'users'
  post 'admin', action: :change_role, controller: 'users'
  get 'my_day', action: :my_day, controller: 'trading_days'
  post 'add_expense', action: :add_expense, controller: 'expenses'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :items do
    member do
      get 'discount'
      patch 'discount'
      get 'cancel_sale'
    end
  end

  delete '/expenses/:id', to: 'expenses#destroy', as: 'expense'

  resources :statuses
  resources :clients
  resources :stores
  resources :trading_days do
    get :autocomplete_item_id, on: :collection
    member do
      patch 'trade_item'
      patch 'trade_item_without_code'
      post 'change_seller'
      get 'close_day'
      get 'unblock_day'
    end
  end
  root 'items#index'
end
