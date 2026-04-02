require "rails_helper"

RSpec.describe SupportMessage, type: :model do
  describe "validations" do
    it "requires message" do
      msg = build(:support_message, message: "")
      expect(msg).not_to be_valid
      expect(msg.errors[:message]).to be_present
    end

    it "requires sender_type" do
      msg = build(:support_message, sender_type: nil)
      expect(msg).not_to be_valid
      expect(msg.errors[:sender_type]).to be_present
    end
  end

  describe "destroy" do
    it "prevents deletion" do
      msg = create(:support_message)
      expect(msg.destroy).to be false
      expect(described_class.exists?(msg.id)).to be true
    end
  end
end
