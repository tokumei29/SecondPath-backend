FactoryBot.define do
  factory :user_record do
    transient do
      owner { create(:user) }
    end

    user_id { owner.supabase_id }
    content { "カルテ内容" }
  end
end
