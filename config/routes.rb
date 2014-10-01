EdgeApp::Application.routes.draw do

  get 'company/index'

  # Don't allow users to sign up themselves, but allow changing passwords
  devise_for :users, :skip => [:registrations]
    as :user do
      #get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'    
      #put 'users/:id' => 'devise/registrations#update', :as => 'user_registration'            
    end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example of regular route:
  get "account" => 'company#account', constraints: { format: 'json' }
  get "company" => 'company#index', constraints: { format: 'html' }
  get "dashboard" => 'dashboards#show'
  get "discussions" => 'discussions#index'
  get "discussions/:id" => 'discussions#show'
  get "employees" => 'employees#index'
  get "my_courses" => 'my_courses#index'
  get "my_courses/:product_id" => 'my_courses#show'
  get "plans" => 'plans#index'
  get "playlists/:id/courses" => 'playlists#courses'
  get "products/:id/reviews" => 'products#reviews'
  get "products/curated" => 'products#curated_index'
  get "profile/current" => 'profile#index'
  get "profile/get_profile_photo" => 'profile#get_profile_photo'
  get "profile/get_profile_photo_thumb" => 'profile#get_profile_photo_thumb'
  get "sign_up" => 'pending_users#new'
  get "search" => 'search#index', constraints: { format: 'html' }
  get "search" => 'search#list', constraints: { format: 'json' }
  get "system" => 'system#surveys'
  get "system/surveys" => 'system#surveys'
  get "system/one_survey" => 'system#one_survey'
  get "system/pending_users" => 'system#pending_users'
  get "teams" => 'teams#index'
  get "user_home" => 'user_home#index'
  get "users/current" => 'user_home#get_user'
  get "vendors" => 'products#vendors'
  get "welcome/edit_password" => 'welcome#edit_password'

  post "sign_up" => 'pending_users#create'
  post "playlist_subscription" => 'user_home#subscribe', constraints: { format: 'json' }
  post "course_subscription" => 'my_courses#subscribe', constraints: { format: 'json' }
  post "users/preferences" => 'user_home#create_preferences', constraints: { format: 'json' }
  post "discussions" => 'discussions#create_discussion', constraints: { format: 'json' }
  post "playlists/:id/courses/:course_id" => 'playlists#add_course', constraints: { format: 'json' }
  post "employees" => 'employees#create', constraints: { format: 'json' }
  post "products/:product_id/reviews" => "discussions#create_review", constraints: { format: 'json' }
  post "system/pending_users/create_users" => 'pending_users#create_user_from_pending', constraints: { format: 'json' }

  put "account/:id" => 'company#update_account', constraints: { format: 'json' }
  put "course_subscription/:id" => 'my_courses#update_subscribtion', constraints: { format: 'json' }
  put "employees/:id" => 'employees#update', constraints: { format: 'json' }
  put "employees/:id/password" => 'employees#change_password', constraints: { format: 'json' }
  put "my_courses/:id/rating" => 'my_courses#update_rating', constraints: { format: 'json' }
  put "playlist_items/ranks" => 'playlists#update_ranks', constraints: { format: 'json' }

  post "profile/upload" => 'profile#upload', constraints: { format: 'json' }
  post "profile" => 'profile#update', constraints: { format: 'json' }

  patch "system/surveys/undo" => 'system#undo_processing'
  patch "system/surveys" => 'system#processing'


  delete "course_subscription/:id" => 'my_courses#unsubscribe', constraints: { format: 'json' }
  delete "playlist_subscription/:id" => 'user_home#unsubscribe', constraints: { format: 'json' }
  delete "playlists/:id/courses/:course_id" => 'playlists#remove_course', constraints: { format: 'json' }
  delete "employees/:id" => 'employees#destroy', constraints: { format: 'json' }

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  resources :products
  resources :playlists

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
