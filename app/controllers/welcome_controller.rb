class WelcomeController < ApplicationController
  def index
    # TODO: add authenitcaiton such as https://github.com/plataformatec/devise
    render layout: "welcome"
  end
end
