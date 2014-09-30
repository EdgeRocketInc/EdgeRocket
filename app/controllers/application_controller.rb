class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # not needed because it's included in other layouts
  # layout 'superhero'


	# Publish an event to the external Keen IO collector
	def publish_keen_io(request_format, collection, data_hash)
	    #TODO make it async
	    if Rails.env.production? && request.format.symbol == request_format
          data_hash[:request_format] = request_format
	      Keen.publish_async(collection, data_hash)
	    end
	end

end
