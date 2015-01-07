class SkillsController < ApplicationController

  before_filter :authenticate_user!
	
	# list the skills
	def list
		skills = Skill.all.order('name ASC')
		@skills = skills.as_json(:include => :recommendations)
		@skills.each { |skill|
			skill['img_url'] = skill['image'].blank? ? nil : view_context.image_path(skill['image'])
			skill['num_items'] = skill['recommendations'].nil? ? 0 : skill['recommendations'].count
		}
	end
end
