class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def google_oauth2
     
		#byebug
    	@user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)
 
	    if !@user.nil? && @user.persisted?
	      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
	      sign_in_and_redirect @user, :event => :authentication
	    else
	      # clean up the session to avoid cookie overflow exception and redirect to the sign in page again
	      #session["devise.google_data"] = request.env["omniauth.auth"]
	      reset_session
	      flash[:error] = 'Access Denied. Please check if your company enabled Google Sign In functionality'
	      redirect_to new_user_session_url
	    end
  	end

	def linkedin

    	@user = User.find_for_linkedin(request.env["omniauth.auth"], current_user)
		#byebug
 
	    if @user.nil? || !@user.persisted?
			# create a new user and account if needed
			user_account = UserAccount.new(nil, request.protocol + request.host_with_port)
			@user = user_account.save_user_linkedin(
				request.env['omniauth.auth'].uid,
				request.env['omniauth.auth'].credentials, 
				request.env['omniauth.auth'].info)
	    end
     	
     	# check the same again
	    if @user.nil? || !@user.persisted?
			# clean up the session to avoid cookie overflow exception and redirect to the sign in page again
			#session["devise.google_data"] = request.env["omniauth.auth"]
			reset_session
			flash[:error] = 'Access Denied. You may need to sign up first'
			redirect_to new_user_session_url
		else	
			flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "LinkedIn"
			sign_in_and_redirect @user, :event => :authentication
	    end

  	end


end