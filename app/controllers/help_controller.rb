class HelpController < ApplicationController

	def index
	    publish_keen_io(:html, :ui_actions, {
	        :user_email => current_user.email,
	        :action => controller_path,
	        :method => action_name
	    })
	end

end
