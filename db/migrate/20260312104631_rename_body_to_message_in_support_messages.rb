class RenameBodyToMessageInSupportMessages < ActiveRecord::Migration[7.1]
  def change
    # カラム名 body を message に変更する
    rename_column :support_messages, :body, :message
  end
end
