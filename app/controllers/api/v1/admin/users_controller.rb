module Api
  module V1
    module Admin
      class UsersController < ApplicationController
        # 認知の歪みのカラム名を定数として定義
        COGNITIVE_FACTORS = [
          :all_or_nothing, :overgeneralization, :mental_filter,
          :disqualifying_the_positive, :jumping_to_conclusions,
          :magnification_minimization, :emotional_reasoning,
          :should_statements, :labeling, :personalization
        ].freeze

        # GET /api/v1/admin/users
        def index
          # クエリがある場合は、profilesテーブルのnameで絞り込み
          if params[:q].present?
            # profileと結合して検索
            @users = User.joins(:profile).where("profiles.name LIKE ?", "%#{params[:q]}%")
          else
            @users = User.includes(:profile)
          end

          @users = @users.order(created_at: :desc)

          render json: {
            status: "success",
            data: @users.map { |user|
              {
                id: user.id,
                name: user.profile&.name || "ユーザー(#{user.id[0..7]})",
                identifier: user.respond_to?(:uid) ? user.uid : user.id,
                created_at: user.created_at&.iso8601(3),
                account_withdrawn_at: user.account_withdrawn_at&.in_time_zone&.iso8601(3)
              }
            }
          }
        end

        # GET /api/v1/admin/users/:id/activity
        def activity
          @user = User.find_by!(supabase_id: params[:id])

          # 各アセスメントの最新1件を取得
          latest_phq9 = @user.phq9_assessments.order(created_at: :desc).first
          latest_cognitive = @user.cognitive_distortion_assessments.order(created_at: :desc).first
          latest_resilience = @user.resilience_assessments.order(created_at: :desc).first

          render json: {
            profile: {
              name: @user.profile&.name || "ユーザー(#{@user.id[0..7]})",
              short_term_goals: @user.profile&.short_term_goals || [],
              long_term_goals:  @user.profile&.long_term_goals || [],
              strengths:       @user.profile&.strengths || [],
              weaknesses:      @user.profile&.weaknesses || [],
              likes:           @user.profile&.likes || [],
              hobbies:         @user.profile&.hobbies || []
            },
            diaries: @user.diaries.order(created_at: :desc).limit(10),
            # PHQ-9：最新の1件のスコアのみ
            phq9_latest: latest_phq9 ? {
              score: latest_phq9.total_score,
              date: latest_phq9.created_at.strftime("%Y/%m/%d")
            } : nil,
            # 認知の歪み：定数を使ってスライス
            cognitive_scores: latest_cognitive ? latest_cognitive.slice(*COGNITIVE_FACTORS) : nil,
            # レジリエンス
            resilience_scores: latest_resilience ? {
              novelty_seeking: latest_resilience.novelty_seeking,
              emotional_regulation: latest_resilience.emotional_regulation,
              adaptive_coping: latest_resilience.adaptive_coping
            } : nil
          }
        end
      end
    end
  end
end
