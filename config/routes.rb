Rails.application.routes.draw do
  get 'users/index'
  get 'committees/index'
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  resources :people do
    collection do
      get 'export', to: 'people#export', as: 'export'
    end
    resources :updates do
      member do
        get :add_tags
        patch :update_tags
      end
    end
    member do
      get 'edit_notes'
      patch 'update_notes'
    end
  end

  get 'refresh_permissions', to: 'users#refresh_permissions'
  get 'permissions', to: 'static_pages#permissions'
  resources :user_permissions, only: [] do
    member do
      patch :toggle
    end
  end
  resources :bugs
  resources :users, only: [:index] do
    member do
      patch :make_admin
      patch :make_permitted
      patch :revoke_permissions
    end
  end
  resources :regions, only: [:index, :show]
  resources :committees, only: [:index, :show]
  resources :tags
  get 'all_updates', to: 'updates#all_updates'
  get '/tags/search', to: 'tags#search'

  root "people#index"
end
