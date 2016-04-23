Rails.application.routes.draw do
  defaults format: :json do
    scope module: :api, constraints: { subdomain: 'api' } do
      scope module: :v1,
            constraints: ApiVersion.new(version: 1, default: true) do
        resources :categories, except: [:new, :edit]
        resources :posts, except: [:new, :edit]
        resources :users, except: [:new, :edit]

        put 'token', to: 'sessions#update'
        post 'signin', to: 'sessions#create'
        get 'signout', to: 'sessions#destroy'
      end
    end
  end
end
