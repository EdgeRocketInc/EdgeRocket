class AddTimestampsToPendingUsers < ActiveRecord::Migration
  def change
    add_timestamps :pending_users
  end
end
