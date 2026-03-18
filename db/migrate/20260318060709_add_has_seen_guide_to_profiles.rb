class AddHasSeenGuideToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :has_seen_guide, :boolean, default: false, null: false
  end
end
