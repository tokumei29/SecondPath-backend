require "rails_helper"

RSpec.describe CognitiveDistortionAssessment, type: :model do
  FACTORS = %i[
    all_or_nothing overgeneralization mental_filter disqualifying_the_positive
    jumping_to_conclusions magnification_minimization emotional_reasoning
    should_statements labeling personalization
  ].freeze

  describe "バリデーション" do
    it "user_id が必須である" do
      assessment = build(:cognitive_distortion_assessment, user_id: nil)
      expect(assessment).not_to be_valid
      expect(assessment.errors[:user_id]).to be_present
    end
  end

  describe "保存前コールバック" do
    it "保存時に因子カラムの合計を total_score に入れる" do
      assessment = create(:cognitive_distortion_assessment)
      FACTORS.each { |f| assessment[f] = 1 }
      assessment.save!

      expect(assessment.total_score).to eq(FACTORS.size)
    end
  end
end
