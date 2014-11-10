class WelcomeController < ApplicationController
  def index
    # authenitcaiton via https://github.com/plataformatec/devise
    if user_signed_in? then

      publish_keen_io(:html, :ui_actions, {
          :user_signed_in => true,
          :user_email => current_user.nil? ? nil : current_user.email,
          :action => controller_path,
          :method => action_name
      })

      # if user signed in first time, force them to change the password
      if current_user.reset_required == true
        redirect_to controller: 'welcome', action: 'edit_password'
      else
        redirect_to controller: 'user_home', action: 'index'
      end
    else	
      publish_keen_io(:html, :ui_actions, {
          :user_signed_in => false,
          :action => controller_path,
          :method => action_name
      })
      redirect_to controller: 'devise/sessions', action: 'new'
    end

  end

  def edit_password

  end
end
