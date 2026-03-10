class CreateDiaries < ActiveRecord::Migration[8.0]
  def change
    create_table :diaries do |t|
      t.string :user_id
      t.text :content
      t.string :mood

      t.timestamps
    end
  end
end
