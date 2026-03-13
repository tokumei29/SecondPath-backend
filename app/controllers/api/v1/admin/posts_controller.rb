class Api::V1::Admin::PostsController < ApplicationController
  # 管理者以外は触らせない（将来的に認証を入れる場所）

  # 記事作成
  def create
    post = Post.new(post_params)
    if post.save
      render json: post, status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # 記事一覧（管理用）
  def index
    posts = Post.order(created_at: :desc)
    render json: posts
  end

  # 記事削除
  def destroy
    post = Post.find(params[:id])
    post.destroy
    head :no_content
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
