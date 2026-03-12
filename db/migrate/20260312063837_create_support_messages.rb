class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users, id: false do |t| # デフォルトの整数IDを無効化
      t.string :id, primary_key: true # UUIDを主キーにする
      t.string :supabase_id, null: false # 予備で持っておく
      t.timestamps
    end
    add_index :users, :supabase_id, unique: true
  end
end
