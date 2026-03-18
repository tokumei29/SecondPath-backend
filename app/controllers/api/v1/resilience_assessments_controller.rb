# app/controllers/api/v1/resilience_assessments_controller.rb
module Api
  module V1
    class ResilienceAssessmentsController < ApplicationController
      before_action :authenticate_user!

      def index
        # ログイン中の本人のデータだけを安全に取得
        # Association (current_user.resilience_assessments) を使うことで
        # 他人の UUID が混ざる余地を排除します
        resiliences = current_user.resilience_assessments.order(created_at: :asc)

        render json: resiliences.map { |r|
          {
            id: r.id,
            # TimeZoneを明示的に指定してフロントと表示を合わせる
            date: r.created_at.in_time_zone("Tokyo").strftime("%Y-%m-%d"),
            total_score: r.total_score,
            novelty_seeking: r.novelty_seeking,
            emotional_regulation: r.emotional_regulation,
            adaptive_coping: r.adaptive_coping
          }
        }
      end

      def create
        # .build を使うことで、params 内の user_id ではなく
        # current_user.id が強制的にセットされます。
        # また、except(:id, :user_id) でフロントからの不要なメタデータを掃除します。
        resilience = current_user.resilience_assessments.build(
          resilience_params.except(:id, :user_id, :created_at, :updated_at)
        )

        if resilience.save
          render json: resilience, status: :created
        else
          render json: { errors: resilience.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def resilience_params
        # 必要な質問項目 (q1~q9) だけを許可
        params.require(:resilience_assessment).permit((1..9).map { |i| "q#{i}".to_sym })
      end
    end
  end
end
