require 'test_helper'

describe Account do 

	def valid_params
		{ company_name: "Comapny Test 1", overview: "compnay overview" }
	end

	it "is valid with params" do
		account = Account.new valid_params

		assert account.valid?, "Can't create valid params: #{account.errors.messages}"
	end
	
end