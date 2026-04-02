require "rails_helper"

RSpec.describe Phq9Assessment, type: :model do
  describe "バリデーション" do
    it "user_id が必須である" do
      assessment = build(:phq9_assessment, user_id: nil)
      expect(assessment).not_to be_valid
      expect(assessment.errors[:user_id]).to be_present
    end

    it "total_score が必須である" do
      assessment = build(:phq9_assessment, total_score: nil)
      expect(assessment).not_to be_valid
      expect(assessment.errors[:total_score]).to be_present
    end
  end
end
