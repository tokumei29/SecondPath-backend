FactoryBot.define do
  factory :diary do
    transient do
      owner { nil }
    end

    user_id { (owner || create(:user)).supabase_id }
    content { "Diary content" }
    mood { "calm" }
  end
end
