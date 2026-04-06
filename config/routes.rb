Rails.application.routes.draw do
  get "/health_check", to: proc { [ 200, {}, [ "ok" ] ] }, via: [ :get, :head ]
  namespace :api do
    namespace :v1 do
      get "posts/index"
      get "posts/show"
      get "me", to: "users#me"
      resources :user_records, only: [ :index, :show ]
      resource :profile, only: [ :show, :update ]
      resources :posts, only: [ :index, :show ]
      resources :diaries, only: [ :index, :create, :show, :update, :destroy ]
      resources :phq9_assessments, only: [ :index, :create ]
      resources :resilience_assessments, only: [ :index, :create ]
      resources :cognitive_distortion_assessments, only: [ :index, :create ]
      resources :text_supports, only: [ :index, :create, :show ] do
        member do
          # /api/v1/text_supports/:id/add_message
          post :add_message
        end
      end

      # Next.js 退会フローから users.account_withdrawn_at（ACCOUNT_WITHDRAWAL_INTERNAL_SECRET 必須）
      post "internal/mark_account_withdrawn", to: "internal/account_withdrawals#create"

      namespace :admin do
        resources :memos
        resources :posts, only: [ :index, :create, :destroy ]
        resources :user_records, only: [ :update, :destroy ]
        resources :text_supports, only: [ :index, :show, :update ] do
          collection { get :stats }
          member { post :reply }
        end
        resources :users, only: [ :index ] do
          resources :user_records, only: [ :index, :create, :show ]
          member do
            get :activity # /api/v1/admin/users/:id/activity
          end
        end
      end
    end
  end
end
