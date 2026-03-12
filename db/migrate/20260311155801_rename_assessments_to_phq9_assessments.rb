class RenameAssessmentsToPhq9Assessments < ActiveRecord::Migration[7.0]
  def change
    rename_table :assessments, :phq9_assessments
  end
end
