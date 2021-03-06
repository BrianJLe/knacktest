AirbnbClone::Application.routes.draw do

  root :to => 'root#root'

  match '/auth/:provider/callback' => 'authentications#create'
  match '/rate' => 'rater#create', :as => 'rate'

  get '/pages/howitworks'
  get '/users/settings'
  get '/spaces/confirm'
  get '/spaces/autocomplete_spaces_title'
  get '/order/express_checkout' => "orders#express_checkout", :as => :pay

  devise_for :admins
  devise_for :users, :controllers => {:registrations => "registrations", :omniauth_callbacks => "users/omniauth_callbacks" } 
  devise_for :users do 
    get "/users/sign_out" => "devise/sessions#destroy", :as => :destroy_user_session
  end
  devise_scope :user do 
 #      root :to => 'devise/registrations#new'
       match '/settings' => 'registrations#settings', as: :settings
  end 

  resources :orders, :new => { :express_checkout => :get }
  resources :comments
  resources :users,    only: [:new, :create, :show, :edit, :update]

  resources :spaces do
  get :autocomplete_spaces_title, :on => :collection
  end

  resources :spaces,   only: [:new, :create, :show, :index, :edit, :update, :destroy] do
    resources :bookings, only: [:new, :edit, :index]
  end

  resources :bookings, only: [:index, :create, :show] do
    member do
      put "cancel_by_user"
      put "cancel_by_owner"
      put "decline"
      put "book"
      put "approve"
      put "complete"
    end
  end

  resources :user_photos, only: [:index] do
    member do
      put "ban"
      put "unban"
    end
  end

  resources :space_photos, only: [:index] do
    member do
      put "ban"
      put "unban"
    end
  end

  resources :messages do
    member do
      post :new
    end
    collection do
      get :reply
    end
  end

  resources :conversations do
    member do
      post :reply
      post :respond
      post :trash
      post :untrash
    end
    collection do
      get :trashbin
      post :empty_trash
      end
    end
  end
