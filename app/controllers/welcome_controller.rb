class WelcomeController < ApplicationController
  def index
    # authenitcaiton via https://github.com/plataformatec/devise
    if user_signed_in? then
      # if user signed in first time, force them to change the password
      if current_user.reset_required == true
        redirect_to controller: 'welcome', action: 'edit_password'
      else
        redirect_to controller: 'user_home', action: 'index'
      end
    else	
      redirect_to controller: 'devise/sessions', action: 'new'
    end
  end

  def edit_password

  end
end
