class AddTotalScoreToCognitiveDistortionAssessments < ActiveRecord::Migration[8.0]
  def change
    add_column :cognitive_distortion_assessments, :total_score, :integer
  end
end
