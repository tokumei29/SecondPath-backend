module Api
  module V1
    class ProfilesController < ApplicationController
      # GET /api/v1/profiles/:user_id
      def show
        profile = Profile.find_or_create_by!(user_id: params[:user_id])
        render json: profile
      end

      def update
        profile = Profile.find_or_initialize_by(user_id: params[:user_id])
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
