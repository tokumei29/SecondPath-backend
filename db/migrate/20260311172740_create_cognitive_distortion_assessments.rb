class CreateCognitiveDistortionAssessments < ActiveRecord::Migration[7.0]
  def change
    create_table :cognitive_distortion_assessments do |t|
      t.references :user, null: false, foreign_key: true
      # 10種類の認知の歪みスコア
      t.integer :all_or_nothing,           null: false, default: 0 # 全か無か思考
      t.integer :overgeneralization,      null: false, default: 0 # 一般化のしすぎ
      t.integer :mental_filter,           null: false, default: 0 # 心のフィルター
      t.integer :disqualifying_the_positive, null: false, default: 0 # プラスの否定
      t.integer :jumping_to_conclusions,  null: false, default: 0 # 結論の飛躍
      t.integer :magnification_minimization, null: false, default: 0 # 拡大解釈・過小評価
      t.integer :emotional_reasoning,     null: false, default: 0 # 感情的決めつけ
      t.integer :should_statements,       null: false, default: 0 # すべき思考
      t.integer :labeling,                null: false, default: 0 # レッテル貼り
      t.integer :personalization,         null: false, default: 0 # 個人化（自分への関連付け）

      t.timestamps
    end
  end
end
