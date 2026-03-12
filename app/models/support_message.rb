class SupportMessage < ApplicationRecord
  belongs_to :text_support

  # 0: user, 1: counselor
  enum :sender_type, { user: 0, counselor: 1 }

  validates :message, presence: true
  validates :sender_type, presence: true

  before_destroy :readonly_check

  private
  def readonly_check
    errors.add(:base, "メッセージの削除は許可されていません")
    throw :abort
  end
end
