class CreateUserRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :user_records do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
