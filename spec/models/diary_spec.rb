require "rails_helper"

RSpec.describe Diary, type: :model do
  it "ユーザーに紐づけて保存できる" do
    diary = create(:diary, owner: create(:user), content: "日記")
    expect(diary.reload.content).to eq("日記")
  end
end
