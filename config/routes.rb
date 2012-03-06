Tutor::Application.routes.draw do


  get "training/check"

  get "training/start"

  get "training/show"

  get "user_word_categories/delete"

  resource :search, :controller => 'search'

  post "tries/start"
  post "tries/check"
  resources :tries, :controller => 'tries'

  resources :word_relations, :only => [:create, :destroy] do
    collection do
      delete :destroy_with_related_word
    end
  end
  resources :user_word_categories, :only => [:destroy]

  resources :user_words
  get "user_words/recent"

  resources :user_categories
  post "user_categories/update_defaults"

  post "users/init"
  resources :users
  resources :sessions, :only => [:new, :create, :destroy]

  root :to => 'user_words#index'

  match '/message', :to => 'pages#message'
  match '/shortkeys', :to => 'pages#shortkeys'

  get 'search/autocomplete_word_text'
  get 'search/autocomplete_user_category_name'

  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
