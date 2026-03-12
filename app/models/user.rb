class User < ApplicationRecord
  self.primary_key = :supabase_id

  has_one  :profile, foreign_key: :user_id, primary_key: :supabase_id, dependent: :destroy
  has_many :diaries, foreign_key: :user_id, primary_key: :supabase_id, dependent: :destroy
  has_many :phq9_assessments, foreign_key: :user_id, primary_key: :supabase_id, dependent: :destroy
  has_many :resilience_assessments, foreign_key: :user_id, primary_key: :supabase_id, dependent: :destroy
  has_many :cognitive_distortion_assessments, foreign_key: :user_id, primary_key: :supabase_id, dependent: :destroy
  has_many :text_supports, foreign_key: :user_id, primary_key: :supabase_id, dependent: :destroy
  has_many :user_records, foreign_key: :user_id, primary_key: :supabase_id, dependent: :destroy
end
