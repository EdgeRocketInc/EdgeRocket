# This model contains vendors of educational materials such as Coursera, Yutube, and etc.
# It should only be populated by EdgeRocket DBA's/developers

class Vendor < ActiveRecord::Base
	has_many :products
end
