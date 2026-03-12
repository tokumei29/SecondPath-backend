class Api::V1::TextSupportsController < ApplicationController
  def create
    @text_support = TextSupport.new(text_support_params)
    @text_support.user_id = params[:user_id]
    @text_support.status = 0

    if @text_support.save
      render json: { status: "success", data: @text_support }, status: :created
    else
      render json: { status: "error", errors: @text_support.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def text_support_params
    params.require(:text_support).permit(:name, :email, :subject, :message)
  end
end
