require "rails_helper"

RSpec.describe TextSupport, type: :model do
  describe "バリデーション" do
    it "message が必須である" do
      support = build(:text_support, message: "")
      expect(support).not_to be_valid
      expect(support.errors[:message]).to be_present
    end

    it "user_id が必須である" do
      support = build(:text_support, user_id: nil)
      expect(support).not_to be_valid
      expect(support.errors[:user_id]).to be_present
    end
  end

  describe "列挙型" do
    it "デフォルトステータスは waiting である" do
      expect(create(:text_support).waiting?).to be true
    end
  end

  describe "削除" do
    it "削除できない" do
      support = create(:text_support)
      expect(support.destroy).to be false
      expect(described_class.exists?(support.id)).to be true
    end
  end
end
