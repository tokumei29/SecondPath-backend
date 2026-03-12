class TextSupport < ApplicationRecord
  validates :message, presence: true
  validates :user_id, presence: true
  has_many :support_messages

  validates :status, inclusion: { in: [ 0, 1, 2 ] }

  # 運用上、削除を禁止するロジック（オプション）
  before_destroy :readonly_check

  private
  def readonly_check
    errors.add(:base, "このレコードは削除できません")
    throw :abort
  end
end
