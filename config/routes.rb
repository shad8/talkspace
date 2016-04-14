Rails.application.routes.draw do
  get 'categories/index'

  get 'categories/show'

  get 'categories/create'

  get 'categories/update'

  get 'categories/destroy'

  defaults format: :json do
    resources :users, except: [:new, :edit]
    resources :posts, except: [:new, :edit]
  end
end
