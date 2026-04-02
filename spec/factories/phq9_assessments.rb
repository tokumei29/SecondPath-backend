FactoryBot.define do
  factory :phq9_assessment do
    user_id { create(:user).supabase_id }
    total_score { 10 }
    q1 { 1 }
    q2 { 1 }
    q3 { 1 }
    q4 { 1 }
    q5 { 1 }
    q6 { 1 }
    q7 { 1 }
    q8 { 1 }
    q9 { 1 }
    suicidal_ideation { false }
  end
end
