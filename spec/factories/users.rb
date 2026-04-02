FactoryBot.define do
  factory :user do
    supabase_id { SecureRandom.uuid }
  end
end
