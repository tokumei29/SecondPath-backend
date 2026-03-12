class Api::V1::Admin::TextSupportsController < ApplicationController
  skip_before_action :authenticate_user, raise: false
  # 管理者用の一覧
  def index
    @supports = TextSupport.all.order(status: :asc, created_at: :desc)
    render json: { status: "success", data: @supports }
  end

  # トーク履歴の詳細
  def show
    @support = TextSupport.find(params[:id])
    @messages = @support.support_messages.order(created_at: :asc)
    render json: {
      status: "success",
      support: @support,
      messages: @messages
    }
  end

  # 回答をLINE形式で追加
  def reply
    @support = TextSupport.find(params[:id])

    ActiveRecord::Base.transaction do
      @message = @support.support_messages.create!(
        body: params[:body],
        sender_type: 1 # Admin (あなた)
      )
      # 送信したらステータスを自動更新
      @support.update!(status: 1)
    end

    render json: { status: "success", data: @message }
  rescue => e
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
