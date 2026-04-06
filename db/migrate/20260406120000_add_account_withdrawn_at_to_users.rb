class AddAccountWithdrawnAtToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :account_withdrawn_at, :datetime
  end
end
