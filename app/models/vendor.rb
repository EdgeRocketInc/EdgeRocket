# This model contains vendors of educational materials such as Coursera, Yutube, and etc.
# It should only be populated by EdgeRocket DBA's/developers

class Vendor < ActiveRecord::Base
	has_many :products

	def self.all_count_by_product
		self.find_by_sql [ \
			'select v.id, v.name, count(p.id) as prod_count ' \
			'from vendors v left outer join products p on v.id=p.vendor_id ' \
			'group by p.vendor_id, v.name, v.id ' \
			'order by prod_count desc' \
		]
	end
end
