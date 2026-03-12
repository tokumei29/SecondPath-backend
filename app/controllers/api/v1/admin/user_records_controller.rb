module Api
  module V1
    module Admin
      class UserRecordsController < ApplicationController
        # POST /api/v1/admin/users/:user_id/user_records
        def create
          @record = UserRecord.new(
            user_id: params[:user_id],
            content: params[:content],
            created_at: params[:date].present? ? Time.zone.parse(params[:date]) : Time.current
          )

          # 保存前に強制的に型をチェック（デバッグ用ログ）
          Rails.logger.info "Saving UserRecord for UUID: #{@record.user_id}"

          if @record.save
            render json: @record, status: :created
          else
            render json: { errors: @record.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # 一覧取得
        def index
          @records = UserRecord.where(user_id: params[:user_id]).order(created_at: :desc)
          user = User.find_by(supabase_id: params[:user_id])

          render json: {
            user_name: user&.profile&.name || "ユーザー",
            records: @records
          }
        end
      end
    end
  end
end
