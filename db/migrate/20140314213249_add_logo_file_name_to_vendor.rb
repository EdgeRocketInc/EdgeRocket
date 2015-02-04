class AddLogoFileNameToVendor < ActiveRecord::Migration
  def change
    add_column :vendors, :logo_file_name, :string
  end
end
