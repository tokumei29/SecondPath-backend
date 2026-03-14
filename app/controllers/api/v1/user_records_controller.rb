# app/controllers/api/v1/user_records_controller.rb
module Api
  module V1
    class UserRecordsController < ApplicationController
      before_action :authenticate_user!

      def index
        # created_at（時間）が新しい順、かつ id（保存順）が新しい順に並べる
        @records = UserRecord.where(user_id: current_user.id)
                            .order(created_at: :desc, id: :desc)

        render json: @records.map { |r| 
          {
            id: r.id,
            date: r.created_at, 
            content: r.content
          }
        }
      end

      def show
        @record = UserRecord.find(params[:id])
        if @record.user_id == current_user.id
          render json: {
            id: @record.id,
            date: @record.created_at, # ここも統一
            content: @record.content
          }
        else
          render json: { error: "Forbidden" }, status: :forbidden
        end
      end
    end
  end
end