insert into accounts(company_name,options) 
	values('Motion Nexus', '{"budget_management":false,"survey":false,"discussions":"builtin","recommendations":false,"disable_search":false,"disable_plans":true,"dashboard_demo":false}')
	returning id;
