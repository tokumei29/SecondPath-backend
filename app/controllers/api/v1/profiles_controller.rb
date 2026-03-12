module Api
  module V1
    class ProfilesController < ApplicationController
      # 認証を必須にする
      before_action :authenticate_user!

      # GET /api/v1/profile
      def show
        # params[:user_id] ではなく、current_user に紐づくプロフィールを取得・作成
        profile = Profile.find_or_create_by!(user_id: current_user.id)
        render json: profile
      end

      # PATCH/PUT /api/v1/profile
      def update
        # 常に「自分のプロフィール」を更新
        profile = Profile.find_or_initialize_by(user_id: current_user.id)

        if profile.update(profile_params)
          render json: profile
        else
          render json: { errors: profile.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def profile_params
        params.require(:profile).permit(
          :name,
          { strengths: [] }, { weaknesses: [] }, { likes: [] },
          { hobbies: [] }, { short_term_goals: [] }, { long_term_goals: [] }
        )
      end
    end
  end
end
