Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "http://localhost:3001",
            "https://second-path-frontend-8qeaejcgy-nkun04183-7822s-projects.vercel.app", # 今の長いURL
            "https://second-path-frontend.vercel.app",                                 # おそらくこれでもアクセスできるはず
            "https://secondpath-app.jp"                                                 # お名前.comのドメイン

    resource "*",
      headers: :any,
      methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
      credentials: true
  end
end