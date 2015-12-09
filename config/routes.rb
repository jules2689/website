Rails.application.routes.draw do
  concern :tag_resources do
    collection { get :tags }
  end

  resources :interests, concerns: :tag_resources, only: [:index, :new, :create, :destroy]

  resources :posts, concerns: :tag_resources, param: :handle do 
    member { post :regenerate_published_key }
  end

  controller :images, path: "images" do
    post :create_github_image
    post :create_gallery
  end

  devise_for :users, :skip => [:registrations]
  resources :users do
    collection do
      resource :sessions, only: [:new, :create, :destroy]
    end
  end

  resources :front_page_widgets, except: :show do
    collection do
      get "/positions", to: :positions, as: :positions
      post "/positions", to: :save_positions, as: :save_positions
    end
  end

  root "front_page_widgets#index"
end
