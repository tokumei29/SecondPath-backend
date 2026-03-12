class UserRecord < ApplicationRecord
  # user_id カラムを使って、User の supabase_id (String) と紐付ける
  belongs_to :user, foreign_key: :user_id, primary_key: :supabase_id

  validates :content, presence: true
end
