insert into accounts(company_name,options) 
	values('Motion Nexus', '{"budget_management":false,"survey":false,"discussions":"builtin","recommendations":false,"disable_search":false,"disable_plans":true,"dashboard_demo":false}');

insert into users(email, first_name, last_name, account_id, encrypted_password) 
	values('tomchikoore@gmail.com', 'Tom', 'Chikoore', CURRVAL('accounts_id_seq'), '$2a$10$mbHAFTi7eODI1qcDmMTk4uxiY1/R11hOSywn.KY1FFdbO88i5bCNe');
	-- Motion!@#

insert into roles(user_id, name) values(CURRVAL('users_id_seq'),'SA');
