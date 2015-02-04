class Budget < ActiveRecord::Base
  belongs_to :user

  def percent_used
    n = (amount_used / amount_allocated) * 100
    n.to_i
  end

end
