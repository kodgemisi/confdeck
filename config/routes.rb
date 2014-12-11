Confman::Application.routes.draw do
  get "schedule/show"

  get "schedule/update"

  get "schedule/destroy"

  get "schedule/create"

  resources :topics, only: [:index]
  resources :topics
  resources :speakers

  get "invitations/accept"
  get '/dashboard', to: 'home#dashboard'
  resources :conferences do
    collection do
      get 'check_slug'
      get 'reset_wizard'
      put 'sync_wizard'
    end
    resources :addresses
    resources :sponsors
    resources :rooms
    resources :slots
    resources :email_templates
    resources :appeals do
      member do
        post 'comment'
        get 'upvote'
        get 'downvote'
        get 'accept'
        get 'reject'
      end
    end
    resource :schedule, :controller => 'schedule' do
      member do
        get 'appeal_list'
      end
    end
    member do
      get 'appeal_types'
      get 'manage'
      get 'basic_information'
      get 'address'
    end
  end

  resources :organizations do
    member do
      post 'invite'
    end
  end

  get "invitations/accept", as: :accept_invitation

  get "home/index"

  devise_for :users

  authenticated :user do
    root :to => "home#dashboard", as: :authenticated_root
  end
  root :to => 'home#index'

  get "settings", to: "settings#index"
  post "settings", to: "settings#update", :as => "update_settings"

end
