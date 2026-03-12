class AddDetailsToDiaries < ActiveRecord::Migration[8.0]
  def change
    add_column :diaries, :good_thing, :text
    add_column :diaries, :improvement, :text
    add_column :diaries, :tomorrow_goal, :text
  end
end
