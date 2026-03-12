FactoryBot.define do
  factory :support_message do
    text_support { nil }
    body { "MyText" }
    sender_type { 1 }
  end
end
