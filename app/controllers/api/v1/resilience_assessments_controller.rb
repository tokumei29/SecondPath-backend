class Api::V1::ResilienceAssessmentsController < ApplicationController
  # SupabaseのJWT認証を必須にする
  before_action :authenticate_user!

  def index
    # URLのparams[:user_id]ではなく、ログイン中の本人のデータだけを取得
    @resiliences = current_user.resilience_assessments.order(created_at: :asc)

    render json: @resiliences.map { |r|
      {
        id: r.id,
        date: r.created_at.in_time_zone("Tokyo").strftime("%Y-%m-%d"),
        total_score: r.total_score,
        novelty_seeking: r.novelty_seeking,
        emotional_regulation: r.emotional_regulation,
        adaptive_coping: r.adaptive_coping
      }
    }
  end

  def create
    # current_user経由でインスタンスを生成（user_idが自動でセットされる）
    @resilience = current_user.resilience_assessments.build(resilience_params)

    if @resilience.save
      render json: @resilience, status: :created
    else
      render json: { errors: @resilience.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def resilience_params
    params.require(:resilience_assessment).permit((1..9).map { |i| "q#{i}".to_sym })
  end
end
