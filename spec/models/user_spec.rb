require "rails_helper"

RSpec.describe User, type: :model do
  describe "関連" do
    it "supabase_id をキーに profile を1つ持つ" do
      user = create(:user)
      profile = create(:profile, owner: user)
      expect(user.reload.profile).to eq(profile)
    end

    it "supabase_id をキーに diaries を複数持つ" do
      user = create(:user)
      diary = create(:diary, owner: user)
      expect(user.reload.diaries).to contain_exactly(diary)
    end
  end
end
