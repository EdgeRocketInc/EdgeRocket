class SystemController < ApplicationController
  def surveys
    @survey = Survey.order()
  end
end