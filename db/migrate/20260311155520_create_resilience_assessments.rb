class CreateResilienceAssessments < ActiveRecord::Migration[8.0]
  def change
    create_table :resilience_assessments do |t|
      t.string :user_id
      t.integer :q1
      t.integer :q2
      t.integer :q3
      t.integer :q4
      t.integer :q5
      t.integer :q6
      t.integer :q7
      t.integer :q8
      t.integer :q9
      t.integer :novelty_seeking
      t.integer :emotional_regulation
      t.integer :adaptive_coping
      t.integer :total_score

      t.timestamps
    end
  end
end
