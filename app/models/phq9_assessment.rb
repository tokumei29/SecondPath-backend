class Phq9Assessment < ApplicationRecord
  validates :user_id, presence: true
  validates :total_score, presence: true
end
