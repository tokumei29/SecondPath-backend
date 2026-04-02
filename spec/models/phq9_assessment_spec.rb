require "rails_helper"

RSpec.describe Phq9Assessment, type: :model do
  describe "validations" do
    it "requires user_id" do
      assessment = build(:phq9_assessment, user_id: nil)
      expect(assessment).not_to be_valid
      expect(assessment.errors[:user_id]).to be_present
    end

    it "requires total_score" do
      assessment = build(:phq9_assessment, total_score: nil)
      expect(assessment).not_to be_valid
      expect(assessment.errors[:total_score]).to be_present
    end
  end
end
