require "rails_helper"

RSpec.describe TextSupport, type: :model do
  describe "validations" do
    it "requires message" do
      support = build(:text_support, message: "")
      expect(support).not_to be_valid
      expect(support.errors[:message]).to be_present
    end

    it "requires user_id" do
      support = build(:text_support, user_id: nil)
      expect(support).not_to be_valid
      expect(support.errors[:user_id]).to be_present
    end
  end

  describe "enum" do
    it "defaults to waiting" do
      expect(create(:text_support).waiting?).to be true
    end
  end

  describe "destroy" do
    it "prevents deletion" do
      support = create(:text_support)
      expect(support.destroy).to be false
      expect(described_class.exists?(support.id)).to be true
    end
  end
end
