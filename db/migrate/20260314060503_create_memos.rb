class CreateMemos < ActiveRecord::Migration[8.0]
  def change
    create_table :memos do |t|
      t.string :user_name
      t.date :date
      t.text :content

      t.timestamps
    end
  end
end
