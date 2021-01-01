Rails.application.routes.draw do
  devise_for :admins, skip: :all
  devise_scope :admin do
    get 'admins/sign_in' => 'admins/sessions#new', as: 'new_admin_session'
    post 'admins/sign_in' => 'admins/sessions#create', as: 'admin_session'
    delete 'admins/sign_out' => 'admins/sessions#destroy', as: 'destroy_admin_session'
  end

  devise_for :customers, skip: :all
  devise_scope :customer do
    get 'customers/sign_in' => 'customers/sessions#new', as: 'new_customer_session'
    post 'customers/sign_in' => 'customers/sessions#create', as: 'customer_session'
    delete 'customers/sign_out' => 'customers/sessions#destroy', as: 'destroy_customer_session'
    get 'customers/sign_up' => 'customers/registrations#new', as: 'new_customer_registration'
    post 'customers' => 'customers/registrations#create', as: 'customer_registration'
    get 'customers/password/edit' => 'customers/registrations#edit', as: 'edit_customer_password'
    patch 'customers/password' => 'customers/registrations#update', as: 'update_customer_password'
    get 'customers/password/new' => 'customers/passwords#new', as: 'new_customer_password'
    post 'customers/password' => 'customers/passwords#create', as: 'create_customer_password'
    post 'customers/guest_sign_in', to: 'customers/sessions#new_guest'
  end

  root "homes#top"
  get "/about" => "homes#about"
  resource :customers, only: [:show, :edit, :update]
  get 'customers/out' => 'customers#out'
  patch 'customers/hide' => 'customers#hide'
  resources :cart_products, only: [:create, :index, :update, :destroy]
  delete "cart_products" => "cart_products#destroy_all"
  resources :products, only: [:index, :show]
  resources :orders, only: [:new, :create, :index, :show]
  resources :orders, only: [:new, :create, :index, :show]
  get "orders/:id/finish" => "orders#finish", as: 'finish'

  post "orders/confirm" => "orders#confirm"
  resources :addresses, only: [:index, :create, :edit, :update, :destroy]

  namespace :admins do
    root "homes#top"
    resources :customers, only: [:index, :show, :edit, :update]
    resources :products, only: [:index, :new, :show, :create, :edit, :update]
    resources :categories, only: [:create, :index, :edit, :update]
    resources :orders, only: [:index, :show, :update]
    resources :order_products, only: [:update]
  end
end
