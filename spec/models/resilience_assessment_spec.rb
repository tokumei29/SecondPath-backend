require "rails_helper"

RSpec.describe ResilienceAssessment, type: :model do
  describe "validations" do
    it "requires user_id" do
      assessment = build(:resilience_assessment, user_id: nil)
      expect(assessment).not_to be_valid
      expect(assessment.errors[:user_id]).to be_present
    end
  end

  describe "before_save" do
    it "derives factor scores and total from q1..q9" do
      assessment = create(
        :resilience_assessment,
        q1: 1, q2: 2, q3: 3,
        q4: 0, q5: 1, q6: 2,
        q7: 3, q8: 3, q9: 3
      )

      expect(assessment.novelty_seeking).to eq(6)
      expect(assessment.emotional_regulation).to eq(3)
      expect(assessment.adaptive_coping).to eq(9)
      expect(assessment.total_score).to eq(18)
    end
  end
end
