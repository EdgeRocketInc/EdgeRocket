require 'test_helper'

class SkillTest < ActiveSupport::TestCase

  test "find matching skill" do
  	skill = Skill.find_a_match("seo")
    assert !skill.nil?
  end

  test "find nil skill" do
  	skill = Skill.find_a_match(nil)
    assert skill.nil?
  end

end
