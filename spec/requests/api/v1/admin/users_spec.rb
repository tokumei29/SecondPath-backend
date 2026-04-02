require "rails_helper"

RSpec.describe "Api::V1::Admin::Users", type: :request do
  describe "GET /api/v1/admin/users" do
    it "returns success with a list of users" do
      u = create(:user)
      create(:profile, owner: u, name: "Admin List User")

      get api_v1_admin_users_path

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["status"]).to eq("success")
      expect(body["data"]).to be_an(Array)
      names = body["data"].map { |row| row["name"] }
      expect(names).to include("Admin List User")
    end

    it "filters by profile name when q is present" do
      alice = create(:user)
      create(:profile, owner: alice, name: "Alice Unique Xyz")
      bob = create(:user)
      create(:profile, owner: bob, name: "Bob Other")

      get api_v1_admin_users_path, params: { q: "Unique Xyz" }

      expect(response).to have_http_status(:ok)
      ids = JSON.parse(response.body)["data"].map { |row| row["id"] }
      expect(ids).to include(alice.supabase_id)
      expect(ids).not_to include(bob.supabase_id)
    end
  end

  describe "GET /api/v1/admin/users/:id/activity" do
    it "returns activity payload for the user" do
      user = create(:user)
      create(:profile, owner: user, name: "Active")

      get activity_api_v1_admin_user_path(user.supabase_id)

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["profile"]["name"]).to eq("Active")
      expect(json).to have_key("diaries")
      expect(json).to have_key("phq9_latest")
      expect(json).to have_key("cognitive_scores")
      expect(json).to have_key("resilience_scores")
    end

    it "returns 404 for unknown supabase_id" do
      get activity_api_v1_admin_user_path(SecureRandom.uuid)

      expect(response).to have_http_status(:not_found)
    end
  end
end
