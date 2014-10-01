insert into accounts(company_name,options, domain) 
	values('Dmitriyev Inc', 
		'{"budget_management":false,"survey":false,"discussions":"builtin","recommendations":false,"disable_search":false,"disable_plans":true,"dashboard_demo":false}',
		'dmitriyev.name')
	returning id;
