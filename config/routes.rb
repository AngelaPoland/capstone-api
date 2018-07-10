Rails.application.routes.draw do

  resources :users do
   resources :intakes, only: [:index, :new, :create, :show]
  end

  get '/users/:id/goal', to: 'users#goal', as: 'user_goal'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
