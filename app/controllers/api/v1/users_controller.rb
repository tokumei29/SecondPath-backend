class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!

  def me
    render json: {
      status: "success",
      user: { id: current_user.id, supabase_id: current_user.supabase_id }
    }
  end
end
