FactoryBot.define do
  factory :profile do
    transient do
      owner { create(:user) }
    end

    user_id { owner.supabase_id }
    name { "Test user" }
  end
end
