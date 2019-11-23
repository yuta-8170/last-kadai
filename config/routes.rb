Rails.application.routes.draw do
    root to: 'toppages#index'
    
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    
    get 'signup', to: 'users#new'
    resources :users do
        member do
            get :followings
            get :followers
            get :likes
            get :matchings
        end
    end
    
    resources :microposts, only: [:create, :destroy, :show] do
        resources :comments, only: :create
    end
    resources :relationships, only: [:create, :destroy]
    resources :favorites, only: [:create, :destroy]
    resources :messages, only: [:create]
    resources :rooms, only: [:create, :show, :index]
    resources :notifications, only: :index
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
