require "rails_helper"

RSpec.describe Profile, type: :model do
  describe "バリデーション" do
    it "user_id が必須である" do
      profile = Profile.new
      expect(profile).not_to be_valid
      expect(profile.errors[:user_id]).to be_present
    end

    it "user_id は一意である" do
      user = create(:user)
      create(:profile, owner: user)
      duplicate = build(:profile, owner: user)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors.of_kind?(:user_id, :taken)).to be true
    end
  end

  describe "デフォルト値" do
    it "新規レコードで配列カラムにデフォルトが入る" do
      profile = Profile.new(user_id: create(:user).supabase_id)
      expect(profile.strengths).to eq([ "", "", "" ])
      expect(profile.short_term_goals).to eq([ "", "", "" ])
    end
  end
end
