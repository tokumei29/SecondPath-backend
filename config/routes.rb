Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "me", to: "users#me"

      resource :profile, only: [ :show, :update ]
      resources :diaries, only: [ :index, :create, :show, :update, :destroy ]
      resources :phq9_assessments, only: [ :index, :create ]
      resources :resilience_assessments, only: [ :index, :create ]
      resources :cognitive_distortion_assessments, only: [ :index, :create ]
      resources :text_supports, only: [ :index, :create ]

      namespace :admin do
        resources :text_supports, only: [ :index, :show, :update ] do
          collection { get :stats }
          member { post :reply }
        end
      end
    end
  end
end
