Tutor::Application.routes.draw do
  resource :search, :controller => 'search'
  get 'search/autocomplete_word_text'
  get 'search/autocomplete_user_category_name'

  resources :trainings do
    member do
      post :check
      put :start
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
      post :update_defaults
    end
  end

  resources :users do
    collection do
      post :init
    end
  end

  resources :sessions, :only => [:new, :create, :destroy]

  root :to => 'user_words#index'

  match '/message', :to => 'pages#message'
  match '/shortkeys', :to => 'pages#shortkeys'

  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
end
