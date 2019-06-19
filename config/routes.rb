Rails.application.routes.draw do
  resources :recipes
  get '/datos_receta', to: 'recipes#datos_receta', as: 'datos_receta'
  get '/eliminar_ingrediente', to: 'recipes#eliminar_ingrediente', as: 'eliminar_ingrediente'

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

  namespace 'api' do
    namespace 'v1' do
      resources :recipes
      get 'like', to: 'recipes#like', as: 'like'
    end 
  end

end
