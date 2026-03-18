# app/controllers/api/v1/user_records_controller.rb
module Api
  module V1
    class UserRecordsController < ApplicationController
      before_action :authenticate_user!

      def index
        # ログインユーザーのIDで明示的に絞り込み、不整合を排除
        records = UserRecord.where(user_id: current_user.id)
                            .order(created_at: :desc, id: :desc)

        render json: records.map { |r|
          {
            id: r.id,
            date: r.created_at,
            content: r.content
          }
        }
      end

      def show
        # 検索の起点に .where(user_id: current_user.id) を含めることで、
        # フロントから送られた params[:id] が「自分の物」である場合のみ取得。
        # これで複数アカウントのIDが混ざっても他人のデータは絶対に触れません。
        record = UserRecord.where(user_id: current_user.id).find_by(id: params[:id])

        if record
          render json: {
            id: record.id,
            date: record.created_at,
            content: record.content
          }
        else
          # IDが一致しない、または自分のものでない場合は 404
          render json: { error: "Record not found" }, status: :not_found
        end
      end
    end
  end
end
