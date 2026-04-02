require "rails_helper"

RSpec.describe UserRecord, type: :model do
  describe "validations" do
    it "requires content" do
      record = build(:user_record, content: "")
      expect(record).not_to be_valid
      expect(record.errors[:content]).to be_present
    end
  end

  describe "associations" do
    it "belongs to user via supabase_id" do
      user = create(:user)
      record = create(:user_record, owner: user)
      expect(record.user).to eq(user)
    end
  end
end
