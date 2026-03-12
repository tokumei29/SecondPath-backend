class Api::V1::CognitiveDistortionAssessmentsController < ApplicationController
  # Supabase認証を必須にする
  before_action :authenticate_user!

  def index
    # params[:user_id] ではなく、トークンから判別した本人のデータのみ取得
    @assessments = current_user.cognitive_distortion_assessments.order(created_at: :asc)
    render json: @assessments.map { |a| format_assessment(a) }
  end

  def create
    # current_user に紐づけて安全に作成
    @assessment = current_user.cognitive_distortion_assessments.build(distortion_params)

    if @assessment.save
      render json: format_assessment(@assessment), status: :created
    else
      render json: { errors: @assessment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def distortion_params
    params.require(:cognitive_distortion_assessment).permit(
      :all_or_nothing, :overgeneralization, :mental_filter,
      :disqualifying_the_positive, :jumping_to_conclusions,
      :magnification_minimization, :emotional_reasoning,
      :should_statements, :labeling, :personalization
    )
  end

  def format_assessment(a)
    {
      id: a.id,
      date: a.created_at.in_time_zone("Tokyo").strftime("%Y-%m-%d"),
      total_score: a.total_score,
      scores: {
        all_or_nothing: a.all_or_nothing,
        overgeneralization: a.overgeneralization,
        mental_filter: a.mental_filter,
        disqualifying_the_positive: a.disqualifying_the_positive,
        jumping_to_conclusions: a.jumping_to_conclusions,
        magnification_minimization: a.magnification_minimization,
        emotional_reasoning: a.emotional_reasoning,
        should_statements: a.should_statements,
        labeling: a.labeling,
        personalization: a.personalization
      }
    }
  end
end
