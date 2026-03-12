class TextSupport < ApplicationRecord
  validates :message, presence: true
  validates :user_id, presence: true
end
