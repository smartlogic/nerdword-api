Nerdword::Application.routes.draw do
  resources :games, :only => [:index], :format => false

  root :to => "root#index"
end
