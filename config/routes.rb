Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  devise_for :people, path: "auth", skip: [ :registrations ]

  root "root#index"

  authenticate :person do
    constraints PersonTypeConstraint.dean do
      resources :students, except: %i[index show]
      resources :collaborators, except: %i[index show]
      resources :teachers, controller: :collaborators, only: %i[new edit create update destroy]
      resources :deans, controller: :collaborators, only: %i[new edit create update destroy]
    end

    resources :students, only: %i[index show]
    resources :teachers, only: %i[index show]
    resources :deans, only: %i[index show]
    resources :collaborators, only: %i[index show]
  end

  unauthenticated do
  end
end
