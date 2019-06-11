Rails.application.routes.draw do
  resources :recipes
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    passwords: "users/passwords"}
    resources :users do
      get 'user_check', :on => :collection
      get 'user_check2', :on => :collection
    end


  get 'welcome/index'
  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'recipe_like', to: 'recipes#recipe_like', as: 'recipe_like'
end
