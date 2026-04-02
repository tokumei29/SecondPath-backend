class DedupeUsersSupabaseIdKeepLatest < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def up
    # `users.supabase_id` の重複を「created_at が最新の行だけ残す」。
    # Postgresの `ctid` を使って物理行を特定して削除する（PK/ID列に依存しないため）。
    execute <<~SQL
      WITH ranked AS (
        SELECT
          ctid,
          ROW_NUMBER() OVER (
            PARTITION BY supabase_id
            ORDER BY created_at DESC, updated_at DESC
          ) AS rn
        FROM users
        WHERE supabase_id IS NOT NULL
      )
      DELETE FROM users u
      USING ranked r
      WHERE u.ctid = r.ctid
        AND r.rn > 1;
    SQL

    # 重複が消えた前提で、`supabase_id` を UNIQUE にする。
    # Railsのバージョン差で `index_exists?` / `remove_index` の引数形式が不整合になり得るため、
    # DBの実在するindexを見てから名前指定でremoveする。
    indexes = connection.indexes(:users)
    supa_index = indexes.find { |i| i.columns == [ "supabase_id" ] }
    remove_index :users, name: supa_index.name if supa_index

    # UNIQUE index を貼る（この名前で追加する）
    # 既に UNIQUE が貼られている場合でも remove しているので必ずこの行で確定する。

    add_index :users, :supabase_id, unique: true, name: "index_users_on_supabase_id"
  end

  def down
    # UNIQUE 制約は戻すが、削除済みデータは復元できない。
    remove_index :users, name: "index_users_on_supabase_id" if index_exists?(:users, name: "index_users_on_supabase_id")

    add_index :users, :supabase_id, unique: false, name: "index_users_on_supabase_id" unless index_exists?(:users, :supabase_id, name: "index_users_on_supabase_id")
  end
end
