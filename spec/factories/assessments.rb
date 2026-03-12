FactoryBot.define do
  factory :assessment do
    user { nil }
    total_score { 1 }
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
