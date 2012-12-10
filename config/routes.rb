ShopUp::Application.routes.draw do

  resources :users,      :except => [:edit]
  resources :sessions,   :only => [:new, :create, :destroy]
  resources :carts,      :only => [:index, :show, :destroy]
  resources :line_items, :only => [:create, :destroy]
  resources :orders,     :only => [:new, :create]

  namespace :admin do
    resources :stores do
      resources :products
      resources :categories
      resources :fields
      resources :assets do
        match "download", :to => "assets#download", :as => "download", :via => "get"
      end

      get 'statistic'
      get 'orders'
      get 'open', :on => :member
      get 'close', :on => :member
    end
  end

  namespace :stores, :path => "/" do
    resources :stores do
      match "/", :to => "stores#catalog", :as => "catalog"
      get "cart"
      get "order"
      match "products/:product_id" ,:to => "stores#product_detail", :as => "product_detail"
      resources :comments,   :only => [:create, :destroy]

    end
  end

  root :to => "pages#home"
  post "/sessions/change_locale", :as=> "locale"

  match '/contact',              :to => 'pages#contact'
  match '/about',                :to => 'pages#about'
  match '/help',                 :to => 'pages#help'
  match '/signup',               :to => 'users#new'
  match '/profile',              :to => 'sessions#profile', :as => 'profile'
  match '/signin',               :to => 'sessions#new'
  match '/signout',              :to => 'sessions#destroy'

  match "/empty_cart_from_store/:store_id", :to => "carts#empty_cart_from_store", :as => "empty_cart_from_store"
  match "/create_order_from_store/:store_id", :to => "orders#create_order_from_store", :as => "create_order_from_store"
  match 'store/:store_id/dynamic_fields_for_category', :to => 'admin/products#dynamic_fields_for_category', :as => 'dynamic_fields_for_category'


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalogs#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalogs#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
