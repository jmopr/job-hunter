Rails.application.routes.draw do
  root to: 'sessions#new'
  resource :sessions, only: [:new, :create, :destroy]

  resource :users do
    resources :jobs, only: [:new, :index, :show, :destroy]
  end
  get 'login'       => 'sessions#new'
  get 'signup'      => 'users#new'
  get 'users/match' => 'jobs#match'
  get 'users/apply' => 'jobs#apply'
  get '/search'     => 'jobs#search'

 resources :jobs do
   collection do
     delete 'destroy_multiple'
   end
 end
end
