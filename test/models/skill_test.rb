require 'test_helper'

class SkillTest < ActiveSupport::TestCase
  test "find matching skill" do
  	skill = Skill.find_a_match("seo")
    assert !skill.nil?
  end
end
