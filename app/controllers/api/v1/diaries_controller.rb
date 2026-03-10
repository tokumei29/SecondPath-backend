module Api
  module V1
    class DiariesController < ApplicationController
      # POST /api/v1/diaries
      def create
        diary = Diary.new(diary_params)

        if diary.save
          render json: { status: 'success', data: diary }, status: :created
        else
          render json: { status: 'error', errors: diary.errors }, status: :unprocessable_entity
        end
      end

      private

      def diary_params
        # Next.jsから送られてくる値を厳格に許可する
        params.require(:diary).permit(:user_id, :content, :mood)
      end
    end
  end
end