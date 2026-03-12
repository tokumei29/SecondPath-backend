# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # フロントエンドのURLを指定（開発環境なら localhost:3000 など）
    origins "http://localhost:3001"

    resource "*",
      headers: :any,
      methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
      credentials: true # クッキーや認証情報を送る場合は必須
  end
end
