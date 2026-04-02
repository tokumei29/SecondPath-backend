require "rails_helper"

RSpec.describe "Api::V1::Diaries", type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { { "X-User-Id" => user.supabase_id } }

  describe "GET /api/v1/diaries" do
    it "returns 401 without X-User-Id" do
      get api_v1_diaries_path

      expect(response).to have_http_status(:unauthorized)
    end

    it "returns the current user's diaries" do
      other = create(:user)
      create(:diary, owner: user, content: "Mine")
      create(:diary, owner: other, content: "Theirs")

      get api_v1_diaries_path, headers: auth_headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["status"]).to eq("success")
      contents = body["data"].map { |d| d["content"] }
      expect(contents).to include("Mine")
      expect(contents).not_to include("Theirs")
    end
  end

  describe "POST /api/v1/diaries" do
    it "creates a diary scoped to the current user" do
      expect {
        post api_v1_diaries_path,
             params: { diary: { content: "Today", mood: "ok" } },
             headers: auth_headers,
             as: :json
      }.to change { user.reload.diaries.count }.by(1)

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body["status"]).to eq("success")
      expect(body.dig("data", "content")).to eq("Today")
      expect(body.dig("data", "user_id")).to eq(user.supabase_id)
    end
  end

  describe "GET /api/v1/diaries/:id" do
    it "returns 404 for another user's diary" do
      other_diary = create(:diary, owner: create(:user))

      get api_v1_diary_path(other_diary), headers: auth_headers

      expect(response).to have_http_status(:not_found)
    end

    it "returns the diary when it belongs to the current user" do
      diary = create(:diary, owner: user, content: "Secret")

      get api_v1_diary_path(diary), headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).dig("data", "content")).to eq("Secret")
    end
  end
end
