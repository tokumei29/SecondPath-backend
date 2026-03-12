class ChangeUserIdTypeInUserRecords < ActiveRecord::Migration[8.0]
  def change
    # 1. 既存の数値用外部キー制約を削除
    remove_foreign_key :user_records, :users rescue nil

    # 2. user_id を integer から string に変更
    # USING句を使って強制的に型変換します
    change_column :user_records, :user_id, :string, using: 'user_id::varchar'

    # 3. あらためて supabase_id を参照する外部キーを貼る
    add_foreign_key :user_records, :users, column: :user_id, primary_key: :supabase_id
  end
end
