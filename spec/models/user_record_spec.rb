require "rails_helper"

RSpec.describe UserRecord, type: :model do
  describe "バリデーション" do
    it "content が必須である" do
      record = build(:user_record, content: "")
      expect(record).not_to be_valid
      expect(record.errors[:content]).to be_present
    end
  end

  describe "関連" do
    it "supabase_id 経由で user に属する" do
      user = create(:user)
      record = create(:user_record, owner: user)
      expect(record.user).to eq(user)
    end
  end
end
