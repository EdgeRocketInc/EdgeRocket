class WelcomeController < ApplicationController
  def index
    # authenitcaiton via https://github.com/plataformatec/devise
    if user_signed_in? then
      redirect_to controller: 'user_home', action: 'index'
    else		
      redirect_to controller: 'devise/sessions', action: 'new'
    end
  end
end
