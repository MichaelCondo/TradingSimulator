Rails.application.routes.draw do
  root 'portfolios#show'
  get 'login', to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'
  get 'search', to: 'trades#search', :as => 'search_trade'
  get 'buy', to: 'trades#buy', :as => 'buy_trade'
  get 'sell', to: 'trades#sell', :as => 'sell_trade'
  get 'buy_order', to: 'trades#buy_order', :as => 'buy_order'
  get 'sell_order', to: 'trades#sell_order', :as => 'sell_order'

  resources :sessions, only: [:create]
  resources :users, only: [:new, :create]
end
