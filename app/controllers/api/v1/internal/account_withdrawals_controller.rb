module Api
  module V1
    module Internal
      # Next.js 退会フローからのみ呼ぶ。ACCOUNT_WITHDRAWAL_INTERNAL_SECRET で保護。
      # users.account_withdrawn_at を立て、管理画面ユーザー一覧から除外する（行は残す）。
      class AccountWithdrawalsController < ActionController::API
        before_action :verify_secret!

        def create
          sid = params.require(:supabase_id)
          user = User.find_by(supabase_id: sid)
          user&.update!(account_withdrawn_at: Time.current)
          head :ok
        end

        private

        def verify_secret!
          provided = request.headers["X-Internal-Secret"].to_s
          expected = ENV["ACCOUNT_WITHDRAWAL_INTERNAL_SECRET"].to_s
          unless expected.present? && ActiveSupport::SecurityUtils.secure_compare(provided, expected)
            head :unauthorized
          end
        end
      end
    end
  end
end
