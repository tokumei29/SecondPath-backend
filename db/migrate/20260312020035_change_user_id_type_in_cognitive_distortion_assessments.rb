class ChangeUserIdTypeInCognitiveDistortionAssessments < ActiveRecord::Migration[7.0]
  def up
    # 既存の integer カラムを削除して uuid で作り直す
    # 外部キー制約がある場合は、先に制約を外す必要があるため remove/add が確実です
    remove_column :cognitive_distortion_assessments, :user_id
    add_column :cognitive_distortion_assessments, :user_id, :uuid, null: false

    # 必要に応じてインデックスを追加
    add_index :cognitive_distortion_assessments, :user_id
  end

  def down
    remove_column :cognitive_distortion_assessments, :user_id
    add_column :cognitive_distortion_assessments, :user_id, :integer
  end
end
