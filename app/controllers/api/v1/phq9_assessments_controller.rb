class Api::V1::Phq9AssessmentsController < ApplicationController
  # Supabaseの認証を必須にする
  before_action :authenticate_user!

  def index
    # 常に current_user に紐づくデータだけを取得
    phq9_assessments = current_user.phq9_assessments.order(created_at: :asc)

    render json: phq9_assessments.map { |a|
      {
        id: a.id,
        date: a.created_at.in_time_zone("Tokyo").strftime("%Y-%m-%d"),
        score: a.total_score
      }
    }
  end

  def create
    # フロントから id や user_id が紛れ込んでも .except で除外。
    # current_user 経由で build することで、正しい user_id を強制セットし衝突を防ぐ。
    phq9_assessment = current_user.phq9_assessments.build(
      phq9_assessment_params.except(:id, :user_id, :created_at, :updated_at)
    )

    # 第9項目の反応をフラグ化
    phq9_assessment.suicidal_ideation = phq9_assessment.q9.to_i > 0

    if phq9_assessment.save
      render json: phq9_assessment, status: :created
    else
      render json: { errors: phq9_assessment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def phq9_assessment_params
    params.require(:phq9_assessment).permit(:total_score, :q1, :q2, :q3, :q4, :q5, :q6, :q7, :q8, :q9)
  end
end
