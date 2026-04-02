require "rails_helper"

RSpec.describe Post, type: :model do
  it "属性を保存できる" do
    post = create(:post, title: "タイトル", content: "本文")
    expect(post.reload.title).to eq("タイトル")
  end
end
