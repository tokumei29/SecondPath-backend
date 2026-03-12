# ApplicationController ではなく API 用のクラスを継承する
class Api::V1::ResilienceAssessmentsController < ActionController::API
  def index
    @resiliences = ResilienceAssessment.where(user_id: params[:user_id]).order(created_at: :asc)
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
    @resilience = ResilienceAssessment.new(resilience_params)
    @resilience.user_id = params[:user_id]

    if @resilience.save
      render json: @resilience, status: :created
    else
      render json: { errors: @resilience.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def resilience_params
    # ★ここを修正！フロントエンドの api.ts で送っている 'resilience_assessment' に合わせる
    params.require(:resilience_assessment).permit((1..9).map { |i| "q#{i}".to_sym })
  end
end
