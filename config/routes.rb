# config/routes.rb
Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'registrations',
    sessions: 'sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  authenticated :user do
    root 'pages#dashboard', as: :authenticated_root
    get 'community', to: 'community#index'
    get 'badges', to: 'badges#index'
    get 'resume_snippet', to: 'snippets#resume'
    get 'connect_account', to: 'pages#connect_account'
    get 'confirm_merge_account', to: 'pages#confirm_merge_account'
    post 'merge_accounts', to: 'pages#merge_accounts'

    # User profile
    get 'profile', to: 'users#show', as: 'user_profile'
    get 'profile/edit', to: 'users#edit', as: 'edit_user_profile'
    patch 'profile', to: 'users#update'

    # Snippets
    get 'my_snippets', to: 'snippets#my_snippets'
    get 'my_contribution', to: 'community#my_contribution'

    # Activities
    get 'recent_activities', to: 'pages#recent_activities'

    # Github
    get 'repositories', to: 'github#repositories', as: 'user_repositories'
    get 'repositories/:id', to: 'github#show_repository', as: 'repository'
    get 'repositories/:repo_id/files/*file_path/edit', to: 'github#edit_file', as: 'edit_repository_file'
    patch 'repositories/:repo_id/files/*file_path', to: 'github#update_file', as: 'update_repository_file'

    # Settings
    get 'settings', to: 'pages#settings'

    # Two factor authentication
    get 'two_factor_authentication', to: 'two_factor_authentication#show'
    post 'two_factor_authentication/send_otp', to: 'two_factor_authentication#send_otp', as: :send_otp_two_factor_authentication
    get 'two_factor_authentication/verify_otp', to: 'two_factor_authentication#verify_otp_form', as: :verify_otp_two_factor_authentication_form
    post 'two_factor_authentication/verify_otp', to: 'two_factor_authentication#verify_otp', as: :verify_otp_two_factor_authentication
    get 'two_factor_authentication/qr_code', to: 'two_factor_authentication#qr_code', as: :qr_code_two_factor_authentication
    post 'two_factor_authentication/enable', to: 'two_factor_authentication#enable'
    post 'two_factor_authentication/disable', to: 'two_factor_authentication#disable', as: :disable_two_factor_authentication

    post 'two_factor_verification/send_otp', to: 'two_factor_verifications#resend_otp', as: :two_factor_verification_send_otp
    get 'two_factor_verification', to: 'two_factor_verifications#show'
    post 'two_factor_verification/verify', to: 'two_factor_verifications#verify'

    post 'run_code', to: 'code_execution#run_code'

    # Projects
    resources :projects, only: [:new, :create, :show, :edit, :update, :destroy] do
      member do
        post :upload_file
      end
    end
  end

  unauthenticated do
    root 'pages#landing', as: :unauthenticated_root
  end

  resources :snippets, only: [:index, :show, :new, :create, :edit, :update, :destroy]
end
