class SupportMessage < ApplicationRecord
  belongs_to :text_support

  validates :body, presence: true
  validates :sender_type, presence: true, inclusion: { in: [ 0, 1 ] }

  # メッセージも単体での削除を禁止する
  before_destroy :readonly_check

  private
  def readonly_check
    errors.add(:base, "メッセージの削除は許可されていません")
    throw :abort
  end
end
