module Authenticatable
  extend ActiveSupport::Concern

  def authenticate_user!
    token = request.headers["Authorization"]&.split(" ")&.last
    payload = decode_token(token)

    if payload
      # Supabaseの sub (UID) を使ってユーザーを特定
      @current_user = User.find_or_create_by!(supabase_id: payload["sub"])
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  private

  def decode_token(token)
    return nil if token.blank?

    # .env に書き込む必要がある秘密鍵
    jwt_secret = ENV["SUPABASE_JWT_SECRET"]
    begin
      # SupabaseのJWTはHS256
      JWT.decode(token, jwt_secret, true, { algorithm: "HS256" }).first
    rescue JWT::DecodeError => e
      Rails.logger.error "JWT Decode Error: #{e.message}"
      nil
    end
  end
end
