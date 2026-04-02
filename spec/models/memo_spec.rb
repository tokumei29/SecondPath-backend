require "rails_helper"

RSpec.describe Memo, type: :model do
  it "persists with attributes" do
    memo = create(:memo, user_name: "佐藤", date: Date.current, content: "メモ")
    expect(memo.reload.user_name).to eq("佐藤")
  end
end
