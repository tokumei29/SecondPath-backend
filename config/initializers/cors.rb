Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "http://localhost:3001",
            "https://second-path-frontend-8qeaejcgy-nkun04183-7822s-projects.vercel.app",
            "https://second-path-frontend.vercel.app",
            "https://secondpath-app.jp",
            "https://demo.secondpath-app.jp"

    resource "*",
      headers: :any,
      methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
      credentials: true
  end
end
