Rails.application.routes.draw do
  root to: 'sessions#new'
  resource :sessions, only: [:new, :create]
  resource :users, only: [:new, :create] do
  # resource :users do
    resources :jobs, only: [:new, :index, :show, :destroy]
  end

  get 'users/match' => 'jobs#match'
  get 'users/apply' => 'jobs#apply'
  get '/search' => 'jobs#search'
end
