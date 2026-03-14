# app/controllers/api/v1/admin/memos_controller.rb
module Api
  module V1
    module Admin
      class MemosController < ApplicationController
        # 必要に応じて admin 認証を入れる
        before_action :set_memo, only: [ :show, :update, :destroy ]

        # GET /api/v1/admin/memos
        def index
          # 最新のメモが上に来るようにソート
          @memos = Memo.order(date: :desc, created_at: :desc)
          render json: @memos
        end

        # GET /api/v1/admin/memos/:id
        def show
          render json: @memo
        end

        # POST /api/v1/admin/memos
        def create
          @memo = Memo.new(memo_params)
          if @memo.save
            render json: @memo, status: :created
          else
            render json: { errors: @memo.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # PATCH/PUT /api/v1/admin/memos/:id
        def update
          if @memo.update(memo_params)
            render json: @memo
          else
            render json: { errors: @memo.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/admin/memos/:id
        def destroy
          @memo.destroy
          head :no_content
        end

        private

        def set_memo
          @memo = Memo.find(params[:id])
        end

        def memo_params
          params.require(:memo).permit(:user_name, :date, :content)
        end
      end
    end
  end
end
