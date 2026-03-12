Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [] do
        resource :profile, only: [ :show, :update ]
        resources :diaries, only: [ :index, :create, :show, :update ]
        resources :phq9_assessments, only: [ :index, :create ]
      resources :resilience_assessments, only: [ :index, :create ]
      resources :cognitive_distortion_assessments, only: [ :index, :create ]
      resources :text_supports, only: [ :create ]
      end
    end
  end
end
