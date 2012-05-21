OnAppTask::Application.routes.draw do
	
	root to: "tickets#index"
	
	resources :tickets, :only => [:index, :create, :new, :show, :update] do
		get 'login', :on => :collection
		post 'authenticate', :on => :collection
		get 'logout', :on => :collection
	end

	resources :sessions, :only => [:new, :create, :destroy]

	namespace :backend do
	  root to: "tickets#index"
	  resources :tickets, :only => [:index, :show, :update] do
			post 'search', :on => :collection
		end
	end

end