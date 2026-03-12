class TextSupport < ApplicationRecord
  belongs_to :user
  has_many :support_messages, dependent: :destroy

  # 0: waiting (回答待ち), 1: replied (回答済み)
  enum :status, { waiting: 0, replied: 1 }, default: :waiting

  validates :message, presence: true
  validates :user_id, presence: true

  before_destroy :readonly_check

  private
  def readonly_check
    errors.add(:base, "このレコードは削除できません")
    throw :abort
  end
end
