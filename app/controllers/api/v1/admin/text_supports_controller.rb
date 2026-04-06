class Api::V1::Admin::TextSupportsController < ApplicationController
  skip_before_action :authenticate_user, raise: false

  # 管理者用の一覧
  def index
    @supports = TextSupport.includes(:user).order(status: :asc, created_at: :desc)
    render json: {
      status: "success",
      data: @supports.map { |s|
        s.as_json.merge(
          "user_account_withdrawn_at" => s.user&.account_withdrawn_at&.iso8601(3)
        )
      }
    }
  end

  # トーク履歴の詳細
  def show
    @support = TextSupport.find(params[:id])
    # DBのカラム名が message なので、フロントが期待する body に変換して返す
    @messages = @support.support_messages.order(created_at: :asc).map do |m|
      {
        id: m.id,
        body: m.message, # ここで message を body という名前で出力
        sender_type: m.sender_type_before_type_cast, # 数値の1を返す
        created_at: m.created_at
      }
    end
    render json: {
      status: "success",
      support: @support,
      messages: @messages # 変換済みの配列
    }
  end

  # 回答をLINE形式で追加
  def reply
    @support = TextSupport.find(params[:id])

    ActiveRecord::Base.transaction do
      # params[:body] で届く内容を、DBカラムの message に保存
      @message = @support.support_messages.create!(
        message: params[:body], # body ではなく message に修正！
        sender_type: 1 # Admin
      )
      # 送信したらステータスを自動更新
      @support.update!(status: 1)
    end

    render json: { status: "success", data: @message }
  rescue => e
    # 失敗時に具体的な理由をログに出す
    logger.error("Reply Error: #{e.message}")
    render json: { status: "error", message: e.message }, status: :unprocessable_entity
  end

  def stats
    unresolved_count = TextSupport.where(status: 0).count
    today_count = TextSupport.where(created_at: Time.zone.now.all_day).count

    render json: {
      unresolved: unresolved_count,
      today: today_count
    }
  end
end
