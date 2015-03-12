class AddUiMessageIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :ui_message_id, :integer
  end
end
