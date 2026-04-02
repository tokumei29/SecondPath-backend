require "rails_helper"

RSpec.describe Memo, type: :model do
  it "属性を保存できる" do
    memo = create(:memo, user_name: "佐藤", date: Date.current, content: "メモ")
    expect(memo.reload.user_name).to eq("佐藤")
  end
end
