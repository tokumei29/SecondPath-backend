class CognitiveDistortionAssessment < ApplicationRecord
  # userテーブルがないので belongs_to は不要
  # その代わり、user_id (UUID) が存在することだけをチェック
  validates :user_id, presence: true

  # 保存前にスコアを自動計算（レジリエンスと同じ構成）
  before_save :calculate_distortion_scores

  private

  def calculate_distortion_scores
    # 10個の因子の値を合計し、total_scoreカラムに代入
    # self[] を使うことで、カラム名を動的に参照して合算
    factors = [
      :all_or_nothing,
      :overgeneralization,
      :mental_filter,
      :disqualifying_the_positive,
      :jumping_to_conclusions,
      :magnification_minimization,
      :emotional_reasoning,
      :should_statements,
      :labeling,
      :personalization
    ]

    self.total_score = factors.sum { |f| self[f].to_i }
  end
end
