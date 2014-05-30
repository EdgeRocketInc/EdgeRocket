class WelcomeController < ApplicationController
  def index
    # authenitcaiton via https://github.com/plataformatec/devise
    if user_signed_in? then
      # if user signed in first time, force them to change the password
      if current_user.sign_in_count > 1
      	redirect_to controller: 'user_home', action: 'index'
      else
      	redirect_to controller: 'devise/registrations', action: 'edit'
      end
    else	
      redirect_to controller: 'devise/sessions', action: 'new'
    end
  end
end
