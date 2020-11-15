Rails.application.routes.draw do
  devise_for :users
  root to: 'projects#index'

  resources :projects
  resources :tasks, except: [:show, :index]
  resources :tasks do
    patch 'raise', on: :member
    patch 'lower', on: :member
  end
end
