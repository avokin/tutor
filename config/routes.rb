Tutor::Application.routes.draw do
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
  get "user_word_categories/delete"

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

  resources :users, :only => [:new, :create, :show, :update, :edit]

  resources :sessions, :only => [:new, :create, :destroy]
  resources :password_resets

  root :to => 'user_words#index'

  match '/message', :to => 'pages#message'
  match '/shortkeys', :to => 'pages#shortkeys'

  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
end
