def create_account(overrides = {})
  FactoryGirl.create(:account, {:company_name => 'ABC Co.', options: "{\"budget_management\":true,\"survey\":true,\"discussions\":\"gplus\",\"recommendations\":true,\"dashboard_demo\":true}"}.merge(overrides))
end

def create_user(account)
  FactoryGirl.create(:user, :email => 'sysop-test@edgerocket.co', :password => '12345678', :account => account)
end