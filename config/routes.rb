Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'registrations',
    sessions: 'sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  authenticated :user do
    root 'pages#dashboard', as: :authenticated_root
    get 'settings', to: 'pages#settings'
    get 'two_factor_authentication', to: 'two_factor_authentication#show'
    post 'two_factor_authentication/enable', to: 'two_factor_authentication#enable'
    post 'two_factor_authentication/disable', to: 'two_factor_authentication#disable'
    post 'two_factor_authentication/send_otp_via_email', to: 'two_factor_authentication#send_otp_via_email'
    post 'two_factor_authentication/send_otp_via_sms', to: 'two_factor_authentication#send_otp_via_sms'
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
  get 'connect_account', to: 'users#connect_account'

  resources :snippets, only: [:index, :show, :new, :create, :edit, :update, :destroy]
end
