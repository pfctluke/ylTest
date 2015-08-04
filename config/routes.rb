ICityTennis::Application.routes.draw do
  # devise_for :users
  devise_for :users, :controllers => { :registrations => 'users',:sessions => 'users/sessions'  }
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
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
  resources :news, :only => [:index, :show]
  resources :messages, :only => [:index]
  resources :tennis_essays, :only => [:index, :show]
  resources :topics, :only => [:index] do
    resources :topic_news, :only => [:index, :show]
  end
  get 'clubs/result' => 'clubs#result'
  resources :clubs
  resources :venues, :only => [:index, :show]
  get 'coaches' => 'coaches#index'
  resources :competitions, :only => [:index, :show]
  resources :orders, :only => [:new, :create, :show, :index] do
    collection do
      post :notify
    end
  end
  resources :competitions do
    get 'teams/new_individual' => "teams#new_individual"
    get 'teams/new_team' => "teams#new_team"
    match 'teams/create_individual', to: 'teams#create_individual', :via => :post
    match 'teams/create_team', to: 'teams#create_team', :via => :post
  end 
  
  resources :teams, :only => [:index, :show]
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
  namespace :admin do
    resources :users
    get 'users/:id/updateStatus' => 'users#updateStatus'
    resources :news
    resources :carousels
    resources :messages
    resources :topics do
      resources :topic_news
    end
    resources :clubs
    get 'clubs/:id/updateStatus' => 'clubs#updateStatus'
    resources :venues
    resources :competitions do
      match 'change_on_home_page_status', to: 'competitions#change_on_home_page_status', :via => :get
      resources :items
      match 'individual_list', to: 'teams#individual_list', :via => :get
      match 'team_list', to: 'teams#team_list', :via => :get
      match 'team/:id/show', to: 'teams#team_show', :via => :get
      resources :teams, :only => [:destroy]
    end    
    resources :orders
    match 'orders/change_annual_fee', to: 'orders#change_annual_fee', :via => :post
  end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  match 'error/browser', to: 'error#browser'
  match 'messages/get_messages', to: 'messages#get_messages', :via => :post
  match 'messages/get_messages_by_size', to: 'messages#get_messages_by_size', :via => :post
  match 'messages/message_upload_view', to: 'messages#message_upload_view', :via => :get
  match 'messages/upload', to: 'messages#upload', :via => :post
  
  match 'users/get_valid_code', to: 'utilities#get_valid_code', :via => :post
  
  match 'users/update', to: 'users#update', :via => :post
  
  get 'users/register' => 'users#register'
  get 'users/result' => 'users#result'
  match 'users/create', to: 'users#create', :via => :post
  get 'users/change_phone' => 'users#change_phone'
  match 'users/check_old_phone' => 'users#check_old_phone', :via => :post
  get 'users/verify_new_phone' => 'users#verify_new_phone'
  match 'users/get_valid_code_by_new_phone', to: 'utilities#get_valid_code_by_new_phone', :via => :post
  match 'users/update_phone' => 'users#update_phone', :via => :post
  get 'users/normal_register' => 'users#normal_register'
  match 'users/normal_create', to: 'users#normal_create', :via => :post
  match 'users/search_users', to: 'users#search_users', :via => :post
  
  get 'elections/index' => 'elections#index'
end
