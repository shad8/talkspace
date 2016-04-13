Rails.application.routes.draw do
  defaults format: :json do
    resources :users, except: [:new, :edit]
    resources :posts, except: [:new, :edit]
  end
end
