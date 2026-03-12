module Api
  module V1
    class DiariesController < ApplicationController
      # Supabase認証を必須にする
      before_action :authenticate_user!

      # GET /api/v1/diaries
      def index
        # params[:user_id] を使わず、current_user の日記だけを取得
        @diaries = current_user.diaries.order(created_at: :desc)
        render json: { status: "success", data: @diaries }
      end

      # POST /api/v1/diaries
      def create
        # current_user に紐づけて作成
        @diary = current_user.diaries.build(diary_params)

        if @diary.save
          render json: { status: "success", data: @diary }, status: :created
        else
          render json: { status: "error", errors: @diary.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/diaries/:id
      def show
        # 他人の日記を見れないよう、current_user の範囲内で検索
        @diary = current_user.diaries.find(params[:id])
        render json: { status: "success", data: @diary }
      rescue ActiveRecord::RecordNotFound
        render json: { status: "error", message: "Not found" }, status: :not_found
      end

      # PATCH/PUT /api/v1/diaries/:id
      def update
        @diary = current_user.diaries.find(params[:id])
        if @diary.update(diary_params)
          render json: { status: "success", data: @diary }
        else
          render json: { status: "error", errors: @diary.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { status: "error", message: "Not found" }, status: :not_found
      end

      # DELETE /api/v1/diaries/:id
      def destroy
        @diary = current_user.diaries.find(params[:id])
        if @diary.destroy
          render json: { status: "success", message: "Deleted successfully" }
        else
          render json: { status: "error", message: "Failed to delete" }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { status: "error", message: "Not found" }, status: :not_found
      end

      private

      def diary_params
        params.require(:diary).permit(:content, :good_thing, :improvement, :tomorrow_goal, :mood)
      end
    end
  end
end
