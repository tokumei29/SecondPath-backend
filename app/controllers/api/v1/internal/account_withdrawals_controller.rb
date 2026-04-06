module Api
  module V1
    module Internal
      # Next.js 退会 API からのみ呼ぶ。ACCOUNT_WITHDRAWAL_INTERNAL_SECRET（Next / Rails で同一値）で保護。
      # users.account_withdrawn_at を立てる（行は残す）。
      class AccountWithdrawalsController < ActionController::API
        before_action :verify_withdrawal_secret!

        def create
          sid = withdrawal_supabase_id
          if sid.blank?
            return render json: { updated: false, reason: "missing_supabase_id" }, status: :bad_request
          end

          user = User.find_by(supabase_id: sid)
          unless user
            Rails.logger.warn("[mark_account_withdrawn] User なし supabase_id=#{sid}")
            return render json: { updated: false, reason: "user_not_found" }, status: :ok
          end

          user.update_column(:account_withdrawn_at, Time.zone.now)
          render json: { updated: true }, status: :ok
        rescue StandardError => e
          Rails.logger.error("[mark_account_withdrawn] #{e.class}: #{e.message}")
          render json: { updated: false, reason: "server_error", message: e.message }, status: :internal_server_error
        end

        private

        def withdrawal_supabase_id
          raw = params[:supabase_id] || params[:user_id]
          raw.to_s.strip.presence
        end

        # 未設定は 503（サイレント成功にしない）。ヘッダ不一致は 401。
        # secure_compare はバイト長不一致で ArgumentError になるため、長さを揃えてから比較する。
        def verify_withdrawal_secret!
          expected = ENV["ACCOUNT_WITHDRAWAL_INTERNAL_SECRET"].to_s.strip
          if expected.blank?
            Rails.logger.error("[mark_account_withdrawn] ACCOUNT_WITHDRAWAL_INTERNAL_SECRET が未設定です")
            render json: {
              error: "misconfigured",
              reason: "withdrawal_secret_not_set_on_server"
            }, status: :service_unavailable
            return
          end

          provided = request.headers["X-Internal-Secret"].to_s.strip
          ok = provided.bytesize == expected.bytesize &&
            ActiveSupport::SecurityUtils.secure_compare(provided, expected)

          unless ok
            render json: { error: "unauthorized", reason: "invalid_withdrawal_secret" }, status: :unauthorized
          end
        end
      end
    end
  end
end
