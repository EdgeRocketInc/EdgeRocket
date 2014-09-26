class OmniauthCallbacksController < Devise::OmniauthCallbacksController   

	def google_oauth2
     
		#byebug
    	@user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)
 
	    if !@user.nil? && @user.persisted?
	      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
	      sign_in_and_redirect @user, :event => :authentication
	    else
	      # clean up the session to avoid cookie overfloew excpetion and redirect to the sign in page again
	      #session["devise.google_data"] = request.env["omniauth.auth"]
	      reset_session
	      flash[:error] = 'Access Denied'
	      redirect_to new_user_session_url
	    end
  	end

end