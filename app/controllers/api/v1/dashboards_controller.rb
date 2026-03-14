module Api
  module V1
    class DashboardsController < ApplicationController
      # 認証を必須にする（current_userを確定させる）
      before_action :authenticate_user!

      def show
  user = current_user
  profile = user.profile

  # ★ データの「中身」ではなく「存在するか」だけをチェック
  has_diaries = user.diaries.exists?

  # 最新1件のアドバイス（これはHomePageのアラート表示に使うので必要）
  latest_advice = user.user_records.order(date: :desc).first

  has_unread_chat = user.text_supports.exists?(status: "replied")

  # ★ 仕様：プロフィールが初期状態で、かつ日記が1件もないならガイドを表示
  show_guide = profile_initial?(profile) && !has_diaries

  render json: {
    user_name: profile&.name.presence || "ユーザー",
    profile: profile, # ProfileSectionで使うため
    # diaries: diaries, # ← Layoutが呼ぶ分には不要！
    has_diaries: has_diaries,
    latest_advice: latest_advice,
    has_unread_chat: has_unread_chat,
    show_guide: show_guide
  }
end

      private

      # 元のJS版 isProfileEmpty のロジックを正確に移植
      def profile_initial?(profile)
        return true if profile.nil?

        # 1. 名前があるか（空白文字を除外）
        has_name = profile.name.present?

        # 2. 各項目に中身（配列の要素や文字列）があるか
        # JS版の .some(key => data[key] && data[key].length > 0) を再現
        has_content = [
          profile.strengths,
          profile.weaknesses,
          profile.likes,
          profile.hobbies,
          profile.short_term_goals,
          profile.long_term_goals
        ].any? { |field| field.present? } # present? は [] や "" を false と判定してくれる

        # 名前もなく、コンテンツもなければ「初期状態（Initial）」
        !has_name && !has_content
      end
    end
  end
end
