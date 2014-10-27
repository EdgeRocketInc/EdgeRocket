class AddColumnLogoFilenameToAccount < ActiveRecord::Migration
  def change
	add_column :accounts, :logo_filename, :string
  end
end
