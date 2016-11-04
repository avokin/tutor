Tutor::Application.routes.draw do
  post 'api/import'
  get 'api/export'

  resource :search, :controller => 'search'
  get 'search/autocomplete_user_word_text'
  get 'search/autocomplete_user_category_name'

  resources :password_resets

  resources :trainings do
    member do
      post :start
      post :learn
      get :learning
    end

    collection do
      post :training_data
      get :training_data
    end
  end

  resources :word_relations, :only => [:create, :destroy] do
    collection do
      delete :destroy_with_related_word
    end
  end

  resources :user_word_categories, :only => [:destroy]
  get 'user_word_categories/delete'

  resources :user_words do
    collection do
      get :recent
    end
  end

  resources :user_categories do
    collection do
      put :merge
    end
  end

  resources :users do
    collection do
      get :new
      put :create
      get :set_target_language
    end

    member do
      get :show
      post :update
      get :edit
    end
  end

  resources :sessions, :only => [:new, :create, :destroy]

  root :to => 'user_words#index'

  match '/message', :to => 'pages#message', via: :get
  match '/shortkeys', :to => 'pages#shortkeys', via: :get

  match '/signup',  :to => 'users#new', via: :get
  match '/signin',  :to => 'sessions#new', via: :get
  match '/signout', :to => 'sessions#destroy', via: :get
end
