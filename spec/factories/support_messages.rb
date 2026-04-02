FactoryBot.define do
  factory :support_message do
    text_support
    message { "返信本文" }
    sender_type { :user }
  end
end
