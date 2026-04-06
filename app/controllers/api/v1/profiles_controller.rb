module Api
  module V1
    class ProfilesController < ApplicationController
      # 認証を必須にする
      before_action :authenticate_user!

      # GET /api/v1/profile
      def show
        render json: current_profile
      end

      # PATCH/PUT /api/v1/profile
      def update
        profile = current_profile
        if profile.update(profile_params)
          render json: profile
        else
          render json: { errors: profile.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      # 並行リクエストでも user_id 一意制約と整合するよう INSERT 優先で取りにいく（find_or_create はレースで重複し得る）
      def current_profile
        @current_profile ||= Profile.create_or_find_by!(user_id: current_user.id)
      end

      def profile_params
        params.require(:profile).permit(
          :name, :has_seen_guide,
          { strengths: [] }, { weaknesses: [] }, { likes: [] },
          { hobbies: [] }, { short_term_goals: [] }, { long_term_goals: [] }
        )
      end
    end
  end
end
