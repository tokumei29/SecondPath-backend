require "rails_helper"

RSpec.describe Profile, type: :model do
  describe "validations" do
    it "requires user_id" do
      profile = Profile.new
      expect(profile).not_to be_valid
      expect(profile.errors[:user_id]).to be_present
    end

    it "enforces uniqueness of user_id" do
      user = create(:user)
      create(:profile, owner: user)
      duplicate = build(:profile, owner: user)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors.of_kind?(:user_id, :taken)).to be true
    end
  end

  describe "defaults" do
    it "fills array fields on new records" do
      profile = Profile.new(user_id: create(:user).supabase_id)
      expect(profile.strengths).to eq([ "", "", "" ])
      expect(profile.short_term_goals).to eq([ "", "", "" ])
    end
  end
end
