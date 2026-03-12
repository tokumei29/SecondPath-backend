class CreateTextSupports < ActiveRecord::Migration[8.0]
  def change
    create_table :text_supports do |t|
      t.string :name
      t.string :email
      t.string :subject
      t.text :message
      t.integer :status
      t.string :user_id

      t.timestamps
    end
  end
end
