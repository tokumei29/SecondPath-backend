module Authenticatable
  extend ActiveSupport::Concern

  def authenticate_user!
    # ヘッダーから送られてきた UUID を取得
    user_id = request.headers["X-User-Id"]

    if user_id.present?
      # DBにユーザーがいなければ作成、いれば取得
      @current_user = User.find_or_create_by!(supabase_id: user_id)
    else
      render json: { error: "User ID missing" }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end
end
