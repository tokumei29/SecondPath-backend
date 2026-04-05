module Api
  module V1
    module Admin
      class UserRecordsController < ApplicationController
        # カルテ機能
        # authenticate_admin! などがあればここに追加
        before_action :set_user_record, only: [ :update, :destroy ]

        # POST /api/v1/admin/users/:user_id/user_records
        def create
          @record = UserRecord.new(
            user_id: params[:user_id],
            content: params[:content],
            # 日付指定があればその日の0時、なければ現在時刻
            created_at: params[:date].present? ? Time.zone.parse(params[:date]) : Time.current
          )

          if @record.save
            render json: @record, status: :created
          else
            render json: { errors: @record.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # GET /api/v1/admin/users/:user_id/user_records
        def index
          # created_at で降順、同じ時間なら id で降順（新しいものが必ず上）
          @records = UserRecord.where(user_id: params[:user_id])
                              .order(created_at: :desc, id: :desc)

          user = User.find_by(supabase_id: params[:user_id])

          render json: {
            user_name: user&.profile&.name || "ユーザー",
            records: @records
          }
        end

        # ★ 追加: PATCH/PUT /api/v1/admin/user_records/:id
        def update
          if @user_record.update(user_record_update_attrs)
            render json: @user_record
          else
            render json: { errors: @user_record.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # ★ 追加: DELETE /api/v1/admin/user_records/:id
        def destroy
          @user_record.destroy
          head :no_content
        end

        private

        def set_user_record
          @user_record = UserRecord.find(params[:id])
        end

        # create と同様、JSON はルート直下の { content, date }（axios のデフォルト）
        def user_record_update_attrs
          permitted = params.permit(:content, :date)
          attrs = {}
          attrs[:content] = permitted[:content] if permitted.key?(:content)
          attrs[:created_at] = Time.zone.parse(permitted[:date]) if permitted[:date].present?
          attrs
        end
      end
    end
  end
end
