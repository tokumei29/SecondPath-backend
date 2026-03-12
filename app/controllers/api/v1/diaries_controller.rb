module Api
  module V1
    class DiariesController < ApplicationController
      # GET /api/v1/users/:user_id/diaries
      def index
        @diaries = Diary.where(user_id: params[:user_id]).order(created_at: :desc)
        # これで created_at, good_thing, improvement 等が含まれた JSON が返ります
        render json: { status: "success", data: @diaries }
      end

      # POST /api/v1/users/:user_id/diaries
      def create
        @diary = Diary.new(diary_params)
        # 修正：URLから取得した user_id をセット
        @diary.user_id = params[:user_id]

        if @diary.save
          render json: { status: "success", data: @diary }, status: :created
        else
          render json: { status: "error", errors: @diary.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        @diary = Diary.find(params[:id])
        render json: { status: "success", data: @diary }
      end

      def update
        @diary = Diary.find(params[:id])
        if @diary.update(diary_params)
          render json: { status: "success", data: @diary }
        else
          render json: { status: "error", errors: @diary.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @diary = Diary.find(params[:id])
        if @diary.destroy
          render json: { status: "success", message: "Deleted successfully" }
        else
          render json: { status: "error", message: "Failed to delete" }, status: :unprocessable_entity
        end
      end

      private

      def diary_params
        params.require(:diary).permit(:content, :good_thing, :improvement, :tomorrow_goal, :mood)
      end
    end
  end
end
