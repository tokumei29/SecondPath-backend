require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it "has one profile keyed by supabase_id" do
      user = create(:user)
      profile = create(:profile, owner: user)
      expect(user.reload.profile).to eq(profile)
    end

    it "has many diaries keyed by supabase_id" do
      user = create(:user)
      diary = create(:diary, owner: user)
      expect(user.reload.diaries).to contain_exactly(diary)
    end
  end
end
