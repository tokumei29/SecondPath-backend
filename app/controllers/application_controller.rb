class ApplicationController < ActionController::API
  include Authenticatable

  def current_user
    @current_user
  end

  def current_user_id
    current_user&.supabase_id
  end
end
