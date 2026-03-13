class Api::V1::PostsController < ApplicationController
  # 記事一覧を取得（最新順）
  def index
    posts = Post.order(created_at: :desc)
    render json: posts
  end

  # 記事詳細を取得
  def show
    post = Post.find(params[:id])
    render json: post
  rescue ActiveRecord::RecordNotFound
    render json: { error: "記事が見つかりませんでした" }, status: :not_found
  end
end
