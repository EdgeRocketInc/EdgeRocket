class SkillsController < ApplicationController

  before_filter :authenticate_user!
	
	# list the skills
	def list
		skills = Skill.all.order('name ASC')
		@skills = skills.as_json
		@skills.each { |skill|
			skill['img_url'] = '/assets/ic_forum_grey600_48dp.png'
			skill['num_items'] = 12
		}
	end
end
