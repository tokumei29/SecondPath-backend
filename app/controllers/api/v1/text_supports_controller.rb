class Api::V1::TextSupportsController < ApplicationController
  # Supabaseの認証を必須にする（ApplicationControllerで定義している前提）
  before_action :authenticate_user!

  def create
    # ログインしているユーザー（current_user）に紐づいたインスタンスを生成
    @text_support = current_user.text_supports.build(text_support_params)

    # ステータス初期値はモデルのデフォルトか、ここで指定
    @text_support.status = 0

    if @text_support.save
      render json: { status: "success", data: @text_support }, status: :created
    else
      render json: { status: "error", errors: @text_support.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # (任意) ユーザーが自分の相談履歴を見れるように index も用意
  def index
    @supports = current_user.text_supports.order(created_at: :desc)
    render json: { status: "success", data: @supports }
  end

  private

  def text_support_params
    params.require(:text_support).permit(:name, :email, :subject, :message)
  end
end
