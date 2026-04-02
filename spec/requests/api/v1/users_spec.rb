require "rails_helper"

RSpec.describe "Api::V1::Users", type: :request do
  describe "GET /api/v1/me" do
    it "returns 401 when X-User-Id is missing" do
      get api_v1_me_path

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to eq("error" => "User ID missing")
    end

    it "returns success and creates the user when X-User-Id is present" do
      uuid = SecureRandom.uuid

      expect {
        get api_v1_me_path, headers: { "X-User-Id" => uuid }
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["status"]).to eq("success")
      expect(body.dig("user", "supabase_id")).to eq(uuid)
      expect(body.dig("user", "id")).to eq(uuid)
    end

    it "returns the existing user on subsequent requests" do
      user = create(:user)
      get api_v1_me_path, headers: { "X-User-Id" => user.supabase_id }

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.dig("user", "supabase_id")).to eq(user.supabase_id)
    end
  end
end
