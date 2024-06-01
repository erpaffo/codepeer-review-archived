Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'registrations',
    sessions: 'sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  authenticated :user do
    root 'pages#dashboard', as: :authenticated_root
    post 'enable_two_factor', to: 'users#enable_two_factor'
    post 'disable_two_factor', to: 'users#disable_two_factor'
    get 'connect_account', to: 'users#connect_account'
  end

  unauthenticated do
    root 'pages#landing', as: :unauthenticated_root
  end

  get 'dashboard', to: 'pages#dashboard'
  get 'profile', to: 'users#profile'
  get 'settings', to: 'pages#settings'
  get 'community', to: 'community#index'
  get 'badges', to: 'badges#index'
  get 'resume_snippet', to: 'snippets#resume'

  resources :snippets, only: [:index, :show, :new, :create, :edit, :update, :destroy]
end
