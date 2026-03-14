# app/controllers/api/v1/dashboards_controller.rb
module Api
  module V1
    class DashboardsController < ApplicationController
      # ログイン必須のサービスなら認証を挟む（既存の仕組みに合わせて）
      # before_action :authenticate_user! 

      def show
        # 1. プロフィール
        profile = current_user.profile
        
        # 2. 日報（最新5件）
        diaries = current_user.diaries.order(created_at: :desc).limit(5)
        
        # 3. 最新のアドバイス（1件）
        latest_advice = current_user.user_records.order(date: :desc).first
        
        # 4. 未読チャットの判定（ロジックは既存のものを参考に）
        # 全件返すのではなく「未読があるか」のフラグだけでフロントは十分なはず
        has_unread_chat = check_unread_exists(current_user)

        # 5. ガイド（WelcomeGuideModal）を表示すべきか判定
        # プロフィールが空、かつ日記が0件なら true
        show_guide = profile_empty?(profile) && diaries.empty?

        render json: {
          user_name: profile&.name || 'ユーザー',
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
        # 名前がなく、かつ主要な項目が一つも埋まっていないか
        data.name.blank? && [
          data.strengths, data.weaknesses, data.likes, 
          data.hobbies, data.short_term_goals, data.long_term_goals
        ].all?(&:blank?)
      end

      def check_unread_exists(user)
        # 簡易的な判定ロジック（実際のテーブル構成に合わせて調整してください）
        # replied ステータスのものが1つでもあれば true とりあえず
        user.text_supports.exists?(status: 'replied')
      end
    end
  end
end