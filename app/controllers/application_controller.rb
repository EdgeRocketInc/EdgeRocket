class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  require 'em-http-request'

  # Also see config/unicorn.rb 
  Thread.new { EventMachine.run }

  # not needed because it's included in other layouts
  # layout 'superhero'

	# Publish an event to the external Keen IO collector
	def publish_keen_io(request_format, collection, data_hash)
	    if (Rails.env.production? || Rails.env.stage?) && request.format.symbol == request_format
          data_hash[:request_format] = request_format
	      Keen.publish_async(collection, data_hash)
	    end
  end

  def ensure_sysop_user
    if current_user
      redirect_to root_path unless current_user.best_role == :sysop
    else
      redirect_to root_path
    end
  end

end
