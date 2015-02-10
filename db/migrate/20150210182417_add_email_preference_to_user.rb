class AddEmailPreferenceToUser < ActiveRecord::Migration
  def change
    add_column :users, :email_preference, :string, limit: 20, default: 'all'
  end
end
