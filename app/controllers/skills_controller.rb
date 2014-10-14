class SkillsController < ApplicationController

  before_filter :authenticate_user!
	
	# list the skills
	def list
		@skills = [Skill.where(hpos: 0).order('vpos ASC'), Skill.where(hpos: 1).order('vpos ASC'), Skill.where(hpos: 2).order('vpos ASC')]

    # @skills = [
		 #    [ { id: 'marketing', name: 'Marketing' },
		 #      { id: 'social_media', name: 'Social Media Marketing' },
		 #      { id: 'seo', name: 'SEO/SEM' },
		 #      # { id: 'copywriting', name: 'Copywriting' }
		 #      { id: 'cs', name: 'Computer Science' },
		 #      { id: 'computer_networking', name: 'Computer Networking' },
		 #      # { id: 'data_centers', name: 'Data Centers' }
		 #      { id: 'data_security', name: 'Data Security' },
		 #      { id: 'data_science', name: 'Data Science' },
		 #      { id: 'web_dev', name: 'Web Development' } ],
		 #    [ { id: 'dbms', name: 'Databases' } ,
		 #      { id: 'soft_dev_methods', name: 'Software Dev. Methodologies' } , # name: 'Software Development Methodologies' }
		 #      { id: 'management', name: 'Management' },
		 #      { id: 'leadership', name: 'Leadership' },
		 #      { id: 'communications', name: 'Communications' },
		 #      { id: 'sales', name: 'Sales' },
		 #      { id: 'hiring', name: 'Hiring & Interviewing' },
		 #      { id: 'presentations', name: 'Effective Presentations' } ],
		 #    [ { id: 'negotiation', name: 'Negotiation' },
		 #      { id: 'strategy', name: 'Strategy' } ,
		 #      { id: 'ops', name: 'Operations' },
		 #      { id: 'pmp', name: 'Project Management' },
		 #      # { id: 'accounting', name: 'Accounting' },
		 #      { id: 'finance', name: 'Finance' },
		 #      # { id: 'spreadsheets', name: 'Spreadsheets' }
		 #      { id: 'ux', name: 'UX/UI' },
		 #      { id: 'graphic_design', name: 'Graphic Design' },
		 #      # { id: 'video_dev', name: 'Video Development' },
		 #      { id: 'product_management', name: 'Product Management' } ]
		 #  ]
	end
end
