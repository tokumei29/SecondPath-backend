class ChangeUserIdInAssessments < ActiveRecord::Migration[7.0]
  def change
    remove_reference :assessments, :user, index: true
    add_column :assessments, :user_id, :string
    add_index :assessments, :user_id
  end
end
