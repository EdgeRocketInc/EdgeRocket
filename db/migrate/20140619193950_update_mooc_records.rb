class UpdateMoocRecords < ActiveRecord::Migration
  def change
  	# update all mooc media types to 'online'
	Product.where("media_type=?", 'mooc').update_all(:media_type => 'online')
  end
end
