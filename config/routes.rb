Rails.application.routes.draw do
  defaults format: :json do
    resources :categories, except: [:new, :edit]
    resources :posts, except: [:new, :edit]
    resources :users, except: [:new, :edit]
  end
end
