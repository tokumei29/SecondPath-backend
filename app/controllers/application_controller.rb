class ApplicationController < ActionController::API
  include Authenticatable

  # 全てのAPIでログインを必須にする
  # before_action :authenticate_user!

  # 仮で置いていた current_user_id は削除してOK
  def current_user_id
    @current_user&.supabase_id
  end
end
