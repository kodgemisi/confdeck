class Subdomain
  def initialize
  end

  def matches?(request)
    if request.subdomain.present? && request.subdomain != 'www'
      true
    else
      false
    end
  end
end


Confman::Application.routes.draw do
  mount RailsAdmin::Engine => '/deck', as: 'rails_admin'

  resources :topics
  resources :speakers
  resources :speeches

  get "invitations/accept"
  get '/dashboard', to: 'home#dashboard'

  constraints Subdomain.new do
    #scope path: "/" do
    resource :conference, path: "/" do
      member do
        get 'apply'
        post 'apply' => "conferences#save_apply"
      end
    end
    #end


    namespace :admin do
      scope path: "/" do
        resource :conference, path: "/", except: [:new, :create] do
          member do
            get 'speech_types'
            get 'manage'
            get 'basic_information'
            get 'address'
            get 'contact_information'
            get 'site_settings'
            get 'search_users'
          end
        end
      end
      resources :roles
      resources :addresses
      resources :sponsors
      resources :rooms
      resources :slots
      resources :email_templates
      resources :speeches do
        collection do
          get "bulk_mail"
          post "send_bulk_mail"
        end
        member do
          post 'comment'
          get 'upvote'
          get 'downvote'
          get 'accept'
          get 'reject'
          get 'send_accept_mail'
          get 'send_reject_mail'
        end
      end
      resource :schedule, :controller => 'schedule' do
        member do
          get 'speech_list'
        end
      end
    end
  end


  resource :conferences do
    collection do
      get 'check_slug'
      get 'reset_wizard'
      put 'sync_wizard'
    end
  end



  resources :organizations do
    member do
      post 'invite'
    end
  end

  get "invitations/accept", as: :accept_invitation

  get "home/index"

  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  resources :users

  authenticated :user do
    root :to => "home#dashboard", as: :authenticated_root
  end

  root :to => 'home#index'
  post "/quick_signup" => 'home#quick_signup'
  get "/quick_social_signup" => 'home#quick_social_signup'

  get "settings", to: "settings#index"
  post "settings", to: "settings#update", :as => "update_settings"

end
