class Api::V1::Phq9AssessmentsController < ApplicationController
  def index
    # ユーザーに紐づくデータを古い順に取得
    @phq9_assessments = Phq9Assessment.where(user_id: params[:user_id]).order(created_at: :asc)

    render json: @phq9_assessments.map { |a|
      {
        id: a.id,
        # フロントの uniqueData ロジックで使うため YYYY-MM-DD 形式
        date: a.created_at.in_time_zone("Tokyo").strftime("%Y-%m-%d"),
        score: a.total_score
      }
    }
  end

  def create
    # フロントの payload { phq9_assessment: { ... } } を受け取る
    @phq9_assessment = Phq9Assessment.new(phq9_assessment_params)
    @phq9_assessment.user_id = params[:user_id]

    # 第9項目の反応をフラグ化
    @phq9_assessment.suicidal_ideation = @phq9_assessment.q9.to_i > 0

    if @phq9_assessment.save
      render json: @phq9_assessment, status: :created
    else
      render json: { errors: @phq9_assessment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def phq9_assessment_params
    params.require(:phq9_assessment).permit(:total_score, :q1, :q2, :q3, :q4, :q5, :q6, :q7, :q8, :q9)
  end
end
