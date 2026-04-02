require "rails_helper"

RSpec.describe "Api::V1::Profiles", type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { { "X-User-Id" => user.supabase_id } }

  describe "GET /api/v1/profile" do
    it "returns 401 without X-User-Id" do
      get api_v1_profile_path

      expect(response).to have_http_status(:unauthorized)
    end

    it "creates and returns a profile for the current user" do
      expect {
        get api_v1_profile_path, headers: auth_headers
      }.to change(Profile, :count).by(1)

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["user_id"]).to eq(user.supabase_id)
    end

    it "returns the existing profile" do
      create(:profile, owner: user, name: "Existing")

      get api_v1_profile_path, headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["name"]).to eq("Existing")
    end
  end

  describe "PATCH /api/v1/profile" do
    it "updates the current user's profile" do
      create(:profile, owner: user, name: "Old")

      patch api_v1_profile_path,
            params: { profile: { name: "New name" } },
            headers: auth_headers,
            as: :json

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["name"]).to eq("New name")
      expect(user.profile.reload.name).to eq("New name")
    end
  end
end
