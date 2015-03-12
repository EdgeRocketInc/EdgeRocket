class UiMessage < ActiveRecord::Base
	has_many :users

	MSG_NEW_COURSE_SUB = 1
	MSG_NEW_LI_RECOMMEND = 2
	MSG_NEW_COURSE_RECOMMEND = 3
end
