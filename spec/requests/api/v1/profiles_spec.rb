require "rails_helper"

RSpec.describe "Api::V1::Profiles", type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { { "X-User-Id" => user.supabase_id } }

  describe "GET /api/v1/profile" do
    it "X-User-Id が無いとき 401 を返す" do
      get api_v1_profile_path

      expect(response).to have_http_status(:unauthorized)
    end

    it "現在ユーザーのプロフィールを作成して返す" do
      expect {
        get api_v1_profile_path, headers: auth_headers
      }.to change(Profile, :count).by(1)

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["user_id"]).to eq(user.supabase_id)
    end

    it "既存のプロフィールを返す" do
      create(:profile, owner: user, name: "Existing")

      get api_v1_profile_path, headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["name"]).to eq("Existing")
    end
  end

  describe "PATCH /api/v1/profile" do
    it "現在ユーザーのプロフィールを更新する" do
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
