module Api
  module V1
    module Internal
      # Next.js 退会 API から呼ぶ。users.account_withdrawn_at を立てる（行は残す）。
      class AccountWithdrawalsController < ActionController::API
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

          # users.account_withdrawn_at は migration の :datetime（PG では timestamp）で Time 系と整合する
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
      end
    end
  end
end
