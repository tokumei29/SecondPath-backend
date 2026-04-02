require "rails_helper"

RSpec.describe Post, type: :model do
  it "persists with attributes" do
    post = create(:post, title: "タイトル", content: "本文")
    expect(post.reload.title).to eq("タイトル")
  end
end
