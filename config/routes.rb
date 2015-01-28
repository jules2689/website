Rails.application.routes.draw do

  devise_for :users, :skip => [:registrations]
  resources :posts, param: :handle do
    collection { get :all_posts }
  end

  controller :application do
    get "/me", to: :me, as: :me
  end

  resources :users do
    collection do
      resource :sessions, only: [:new, :create, :destroy]
    end
  end

  root "application#index"
end
