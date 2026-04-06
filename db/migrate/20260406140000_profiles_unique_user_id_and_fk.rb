# frozen_string_literal: true

class ProfilesUniqueUserIdAndFk < ActiveRecord::Migration[8.0]
  def up
    say_with_time "Removing invalid / duplicate profiles" do
      Profile.reset_column_information

      Profile.where(user_id: [ nil, "" ]).delete_all

      orphan_scope = Profile.where.not(user_id: User.select(:supabase_id))
      deleted_orphans = orphan_scope.delete_all
      say "Deleted #{deleted_orphans} orphan profile(s)", true if deleted_orphans.positive?

      duplicate_user_ids =
        Profile.group(:user_id).having("COUNT(*) > 1").pluck(:user_id)

      duplicate_user_ids.each do |uid|
        keeper = Profile.where(user_id: uid).order(:created_at, :id).first
        next unless keeper

        Profile.where(user_id: uid).where.not(id: keeper.id).delete_all
      end
    end

    change_column_null :profiles, :user_id, false

    if index_exists?(:profiles, :user_id)
      remove_index :profiles, :user_id
    end
    add_index :profiles, :user_id, unique: true

    return if foreign_key_exists?(:profiles, :users)

    add_foreign_key :profiles, :users, column: :user_id, primary_key: :supabase_id, on_delete: :cascade
  end

  def down
    remove_foreign_key :profiles, :users if foreign_key_exists?(:profiles, :users)

    remove_index :profiles, :user_id if index_exists?(:profiles, :user_id)

    change_column_null :profiles, :user_id, true
  end
end
