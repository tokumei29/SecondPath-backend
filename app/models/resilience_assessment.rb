class ResilienceAssessment < ApplicationRecord
  validates :user_id, presence: true

  # 保存前に各スコアを自動計算
  before_save :calculate_resilience_scores

  private

  def calculate_resilience_scores
    # 各因子は3問ずつの合計（0-9点）
    self.novelty_seeking    = q1.to_i + q2.to_i + q3.to_i
    self.emotional_regulation = q4.to_i + q5.to_i + q6.to_i
    self.adaptive_coping    = q7.to_i + q8.to_i + q9.to_i

    # 総合点（0-27点）
    self.total_score = novelty_seeking + emotional_regulation + adaptive_coping
  end
end
