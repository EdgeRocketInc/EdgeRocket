class User < ActiveRecord::Base

	def self.all_incomplete
		sql = "select email, count(mcc.id) " \
			+ "from users u left join (select * from my_courses where status<>'compl') mcc on u.id=mcc.user_id " \
			+ "where lower(email) in ('alexey@edgerocket.co', 'peter@edgerocket.co') " \
			+ "group by email having count(mcc.id) > 0"
    	self.find_by_sql sql
	end

end

