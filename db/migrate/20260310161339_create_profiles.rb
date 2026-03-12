class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles do |t|
      t.string :user_id, null: false, index: { unique: true }
      t.string :name, default: ""
      t.string :strengths, array: true, default: []
      t.string :weaknesses, array: true, default: []
      t.string :likes, array: true, default: []
      t.string :hobbies, array: true, default: []
      t.string :short_term_goals, array: true, default: []
      t.string :long_term_goals, array: true, default: []

      t.timestamps
    end
  end
end
