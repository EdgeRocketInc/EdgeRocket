require 'test_helper'

class BudgetTest < ActiveSupport::TestCase
  test "budget percent" do
    b = Budget.find(101)
    assert b.percent_used > 0, "used percent is wrong"
  end
end
