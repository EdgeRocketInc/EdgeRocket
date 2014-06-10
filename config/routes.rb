EdgeApp::Application.routes.draw do

  # Don't alloow users to sign up themselves, but allow changing passwords
  devise_for :users, :skip => [:registrations]
    as :user do
      get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'    
      put 'users/:id' => 'devise/registrations#update', :as => 'user_registration'            
    end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  get "search" => 'search#index'
  get "my_courses" => 'my_courses#index'
  get "my_courses/:product_id" => 'my_courses#show'
  get "user_home" => 'user_home#index'
  get "dashboard" => 'dashboards#show'
  get "plans" => 'plans#index'
  get "playlists/:id/courses" => 'playlists#courses'
  get "discussions" => 'discussions#index'
  get "discussions/:id" => 'discussions#show'
  get "users/current" => 'user_home#get_user'
  get "employees" => 'employees#index'
  get "teams" => 'teams#index'
  get "products/:id/reviews" => 'products#reviews'

  post "playlist_subscription" => 'user_home#subscribe'
  post "course_subscription" => 'my_courses#subscribe'
  post "users/preferences" => 'user_home#create_preferences'
  post "discussions" => 'discussions#create_discussion'
  post "playlists/:id/courses/:course_id" => 'playlists#add_course'
  post "employees" => 'employees#create'
  post "products/:product_id/reviews" => "discussions#create_review"
  
  put "course_subscription/:id" => 'my_courses#update_subscribtion'
  put "employees/:id" => 'employees#update'
  put "my_courses/:id/rating" => 'my_courses#update_rating'

  delete "course_subscription/:id" => 'my_courses#unsubscribe'
  delete "playlist_subscription/:id" => 'user_home#unsubscribe'
  delete "playlists/:id/courses/:course_id" => 'playlists#remove_course'
  delete "employees/:id" => 'employees#destroy'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  resources :products
  resources :playlists

  # STUBS FOR FUTURE ROUTES
  get 'corp_home' => 'corp_home#index'
  

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
