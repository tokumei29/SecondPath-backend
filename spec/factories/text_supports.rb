FactoryBot.define do
  factory :text_support do
    name { "山田" }
    email { "user@example.com" }
    subject { "相談" }
    message { "本文です" }
    user_id { create(:user).supabase_id }
  end
end
