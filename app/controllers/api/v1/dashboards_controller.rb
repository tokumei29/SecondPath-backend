module Api
  module V1
    class DashboardsController < ApplicationController
      before_action :authenticate_user!

      def show
        user = current_user
        profile = user.profile

        # ★ 修正：中身（最新5件）を配列で取得する
        # これをしないと HomePage の .map などでエラーになります
        diaries = user.diaries.order(created_at: :desc).limit(5)

        latest_advice = user.user_records.order(date: :desc).first
        has_unread_chat = user.text_supports.exists?(status: "replied")

        # ★ 判定仕様を維持
        # .empty? は diaries が 0件の時に true になります
        show_guide = profile_initial?(profile) && diaries.empty?

        render json: {
          user_name: profile&.name.presence || "ユーザー",
          profile: profile,
          diaries: diaries, # ★ 配列として返す
          latest_advice: latest_advice,
          has_unread_chat: has_unread_chat,
          show_guide: show_guide
        }
      end

      private

      def profile_initial?(profile)
        return true if profile.nil?
        has_name = profile.name.present?
        has_content = [
          profile.strengths, profile.weaknesses, profile.likes,
          profile.hobbies, profile.short_term_goals, profile.long_term_goals
        ].any? { |field| field.present? }
        !has_name && !has_content
      end
    end
  end
end
