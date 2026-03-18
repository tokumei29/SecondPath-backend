module Api
  module V1
    class TextSupportsController < ApplicationController
      before_action :authenticate_user!

      # 相談一覧を取得
      def index
        # @current_user.id を直接使うのではなく Association を活用し不整合を排除
        supports = current_user.text_supports.includes(:support_messages).order(updated_at: :desc)

        render json: supports.map { |support|
          last_msg = support.support_messages.last
          support.as_json.merge({
            last_message_sender_type: last_msg&.sender_type,
            last_message_at: last_msg&.created_at
          })
        }
      end

      # 特定の相談とそのチャット履歴を取得
      def show
        # 自分の持ち物の中から検索。他人のIDなら自動で RecordNotFound
        text_support = current_user.text_supports.find(params[:id])

        render json: text_support.as_json(
          only: [ :id, :subject, :message, :status, :created_at ],
          include: {
            support_messages: {
              only: [ :id, :message, :sender_type, :created_at ]
            }
          }
        )
      end

      # ユーザーからの追加メッセージ投稿
      def add_message
        text_support = current_user.text_supports.find(params[:id])

        # message を作成
        message = text_support.support_messages.build(
          message: params.dig(:support_message, :message),
          sender_type: :user
        )

        if message.save
          text_support.waiting!
          render json: message, status: :created
        else
          render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # 新規相談作成
      def create
        # フロントから id や user_id が紛れ込んでも .except で除去し、
        # 常に現在のログインユーザーに紐付けることで楽観排他エラーを防ぐ
        text_support = current_user.text_supports.build(text_support_params.except(:id, :user_id))
        text_support.status = :waiting

        if text_support.save
          render json: text_support, status: :created
        else
          render json: { errors: text_support.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def text_support_params
        # 必要最小限のキーのみを許可
        params.require(:text_support).permit(:name, :email, :subject, :message)
      end
    end
  end
end
