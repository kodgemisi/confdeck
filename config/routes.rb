Confman::Application.routes.draw do
  resources :slots

  get "invitations/accept"

  resources :conferences do
    resources :sponsors
  end

  resources :organizations do
    member do
      post 'invite'
    end
  end

  get "invitations/accept", as: :accept_invitation

  get "home/index"

  devise_for :users

  root :to => 'home#index'

end
