module Api
  module V1
    class TextSupportsController < ApplicationController
      before_action :authenticate_user!

      # 相談一覧を取得
      def index
        @text_supports = current_user.text_supports.order(created_at: :desc)
        render json: @text_supports.as_json(only: [ :id, :subject, :message, :status, :created_at ])
      end

      # 特定の相談とそのチャット履歴を取得
      def show
        @text_support = current_user.text_supports.find(params[:id])
        render json: @text_support.as_json(
          only: [ :id, :subject, :message, :status, :created_at ],
          include: {
            support_messages: {
              # ここを message に修正
              only: [ :id, :message, :sender_type, :created_at ]
            }
          }
        )
      end

      # ユーザーからの追加メッセージ投稿
      # POST /api/v1/text_supports/:id/add_message
      def add_message
        @text_support = current_user.text_supports.find(params[:id])
        # support_message というキーで届く message を作成
        @message = @text_support.support_messages.build(
          message: params[:support_message][:message],
          sender_type: :user
        )

        if @message.save
          @text_support.waiting! # ステータスを「回答待ち」に更新
          render json: @message, status: :created
        else
          render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # 新規相談作成
      def create
        @text_support = current_user.text_supports.build(text_support_params)
        @text_support.status = :waiting # 最初は必ず回答待ち

        if @text_support.save
          render json: @text_support, status: :created
        else
          render json: { errors: @text_support.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def text_support_params
        params.require(:text_support).permit(:name, :email, :subject, :message)
      end
    end
  end
end
