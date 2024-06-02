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
    post 'two_factor_authentication/send_otp', to: 'two_factor_authentication#send_otp', as: :send_otp_two_factor_authentication
    get 'two_factor_authentication/verify_otp', to: 'two_factor_authentication#verify_otp_form', as: :verify_otp_two_factor_authentication_form
    post 'two_factor_authentication/verify_otp', to: 'two_factor_authentication#verify_otp', as: :verify_otp_two_factor_authentication
    get 'two_factor_authentication/qr_code', to: 'two_factor_authentication#qr_code', as: :qr_code_two_factor_authentication
    post 'two_factor_authentication/enable', to: 'two_factor_authentication#enable'
    post 'two_factor_authentication/disable', to: 'two_factor_authentication#disable', as: :disable_two_factor_authentication
    post 'two_factor_verification/send_otp', to: 'two_factor_verifications#resend_otp', as: :two_factor_verification_send_otp
    get 'two_factor_verification', to: 'two_factor_verifications#show'
    post 'two_factor_verification/verify', to: 'two_factor_verifications#verify', as: :two_factor_verification_verify
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
