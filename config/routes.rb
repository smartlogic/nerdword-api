Nerdword::Application.routes.draw do
  resources :games, :only => [:index, :show, :create], :format => false do
    resources :turns, :only => [:index]
  end

  match "/docs" => Raddocs::App, :anchor => false

  root :to => "root#index"
end
