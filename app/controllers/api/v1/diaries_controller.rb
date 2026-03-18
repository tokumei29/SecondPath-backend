module Api
  module V1
    class DiariesController < ApplicationController
      before_action :authenticate_user!

      # GET /api/v1/diaries
      def index
        diaries = current_user.diaries.order(created_at: :desc)
        render json: { status: "success", data: diaries }
      end

      # POST /api/v1/diaries
      def create
        # フロントから id や user_id が混じっていても .except で除外。
        # current_user.diaries.build により、正しい user_id を強制的にセットします。
        diary = current_user.diaries.build(diary_params.except(:id, :user_id, :created_at, :updated_at))

        if diary.save
          render json: { status: "success", data: diary }, status: :created
        else
          render json: { status: "error", errors: diary.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/diaries/:id
      def show
        diary = current_user.diaries.find(params[:id])
        render json: { status: "success", data: diary }
      rescue ActiveRecord::RecordNotFound
        render json: { status: "error", message: "Not found" }, status: :not_found
      end

      # PATCH/PUT /api/v1/diaries/:id
      def update
        # 自分の日記の中から ID で検索。他人のIDなら見つからずエラー（安全）
        diary = current_user.diaries.find(params[:id])

        # 更新時も id や user_id を除外。これで ID の不整合によるエラーを防ぎます。
        if diary.update(diary_params.except(:id, :user_id, :created_at, :updated_at))
          render json: { status: "success", data: diary }
        else
          render json: { status: "error", errors: diary.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { status: "error", message: "Not found" }, status: :not_found
      end

      # DELETE /api/v1/diaries/:id
      def destroy
        diary = current_user.diaries.find(params[:id])
        if diary.destroy
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
