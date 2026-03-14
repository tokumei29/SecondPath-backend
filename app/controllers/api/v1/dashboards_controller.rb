# app/controllers/api/v1/dashboards_controller.rb
module Api
  module V1
    class DashboardsController < ApplicationController
      # ★ これを必ず有効にする（または既存の認証用メソッドを呼ぶ）
      # これがないと current_user が nil になり、さっきのエラーが出ます
      before_action :authenticate_user!

      def show
        # current_user が確実に存在することを前提に処理できる
        profile = current_user.profile
        diaries = current_user.diaries.order(created_at: :desc).limit(5)
        latest_advice = current_user.user_records.order(date: :desc).first

        # 未読があるかどうかの判定
        has_unread_chat = current_user.text_supports.exists?(status: "replied")

        # ガイドを出すかどうかの判定（ロジックをここに集約）
        show_guide = profile_empty?(profile) && diaries.empty?

        render json: {
          user_name: profile&.name || "ユーザー",
          profile: profile,
          diaries: diaries,
          latest_advice: latest_advice,
          has_unread_chat: has_unread_chat,
          show_guide: show_guide
        }
      end

      private

      def profile_empty?(data)
        return true if data.nil?
        data.name.blank? && [
          data.strengths, data.weaknesses, data.likes,
          data.hobbies, data.short_term_goals, data.long_term_goals
        ].all?(&:blank?)
      end
    end
  end
end
