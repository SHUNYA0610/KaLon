Rails.application.routes.draw do
  # 顧客用
  # URL /customers/sign_in ...
  devise_for :user,skip: [:passwords], controllers: {
    registrations: "user/registrations",
    sessions: 'user/sessions'
  }
  
  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }
      
  root to: 'user/homes#top'
  get 'home/about' => 'user/homes#about', as: 'about'

  scope module: :user do
    
  resources :posts, only: [:index, :create, :show, :edit, :update, :destroy] do
    resources :post_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
  
  resources :users, only: [:index, :show, :update, :edit]
  
  end

end
