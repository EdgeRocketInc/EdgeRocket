require 'test_helper'

class BudgetsTest < ActiveSupport::TestCase
  test "budget percent" do
    b = Budgets.find(101)
    assert b.percent_used > 0, "used percent is wrong"
  end
end
