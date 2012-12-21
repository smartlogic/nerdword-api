Nerdword::Application.routes.draw do
  resources :games, :only => [:index, :show, :create], :format => false do
    member do
      post :action => :play
    end

    resources :turns, :only => [:index, :show]
  end

  resources :users, :only => [:create], :format => false

  match "/docs" => Raddocs::App, :anchor => false

  root :to => "root#index"
end
