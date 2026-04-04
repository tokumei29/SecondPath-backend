require "rails_helper"

RSpec.describe "Api::V1::Posts", type: :request do
  describe "GET /api/v1/posts" do
    it "一覧を返す" do
      create(:post, title: "A", content: "本文A")

      get api_v1_posts_path

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body).to be_an(Array)
      expect(body.first["title"]).to eq("A")
    end
  end

  describe "GET /api/v1/posts/:id" do
    it "記事を返す" do
      post = create(:post, title: "詳細", content: "内容")

      get api_v1_post_path(post)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["title"]).to eq("詳細")
    end

    it "存在しない id なら 404 を返す" do
      get api_v1_post_path(999_999)

      expect(response).to have_http_status(:not_found)
    end
  end
end
