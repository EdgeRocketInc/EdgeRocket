insert into accounts(company_name,options,overview) 
	values('Mark Eagle', 
		'{"budget_management":false,"survey":true,"discussions":"builtin","recommendations":false,"disable_search":false,"disable_plans":true,"dashboard_demo":false}',
		'<p>EdgeRocket provides access to learning resources -- such as online courses, books and videos -- on business and technical topics.  The playlists (listed below and on My Courses page) are curated collections of content about specific job functions or important subjects.  As you complete various courses or content, you&#39;re invited to share your comments and recommendations with the team!</p><p>For a screencast about basic functionality, click <a href="https://vimeo.com/100743097">EdgeRocket Introduction</a>.</p><p>Questions?  Contact <a href="email:support@edgerocket.co">support@edgerocket.co</a></p>');

insert into users(email, first_name, last_name, account_id, encrypted_password) 
	values('mark.eagle@comcast.net', 'Mark', 'Eagle', CURRVAL('accounts_id_seq'), '$2a$10$ii/dDmLiNPFA6EbB4x3Di.4YyCnlIvu1Sfd2fEVOvAAUPgmE67lU.');
	-- EdgeFr@@

insert into roles(user_id, name) values(CURRVAL('users_id_seq'),'SA');

insert into playlists(title, mandatory, description, account_id)
	select title, mandatory, description, CURRVAL('accounts_id_seq') from playlists where id=3008;

insert into playlist_items(playlist_id, product_id, rank)
	select CURRVAL('playlists_id_seq'), product_id, rank from playlist_items where playlist_id=3008;

-- ***

insert into accounts(company_name,options,overview) 
	values('InteliVideo', 
		'{"budget_management":false,"survey":true,"discussions":"builtin","recommendations":false,"disable_search":false,"disable_plans":true,"dashboard_demo":false}',
		'<p>EdgeRocket provides access to learning resources -- such as online courses, books and videos -- on business and technical topics.  The playlists (listed below and on My Courses page) are curated collections of content about specific job functions or important subjects.  As you complete various courses or content, you&#39;re invited to share your comments and recommendations with the team!</p><p>For a screencast about basic functionality, click <a href="https://vimeo.com/100743097">EdgeRocket Introduction</a>.</p><p>Questions?  Contact <a href="email:support@edgerocket.co">support@edgerocket.co</a></p>');

insert into users(email, first_name, last_name, account_id, encrypted_password) 
	values('brad@intelivideo.com', 'Brad', 'Brown', CURRVAL('accounts_id_seq'), '$2a$10$ii/dDmLiNPFA6EbB4x3Di.4YyCnlIvu1Sfd2fEVOvAAUPgmE67lU.');
	-- EdgeFr@@

insert into roles(user_id, name) values(CURRVAL('users_id_seq'),'SA');

insert into playlists(title, mandatory, description, account_id)
	select title, mandatory, description, CURRVAL('accounts_id_seq') from playlists where id=3008;

insert into playlist_items(playlist_id, product_id, rank)
	select CURRVAL('playlists_id_seq'), product_id, rank from playlist_items where playlist_id=3008;

-- ***

insert into accounts(company_name,options,overview) 
	values('VENTURE LAW ADVISORS, LLC', 
		'{"budget_management":false,"survey":true,"discussions":"builtin","recommendations":false,"disable_search":false,"disable_plans":true,"dashboard_demo":false}',
		'<p>EdgeRocket provides access to learning resources -- such as online courses, books and videos -- on business and technical topics.  The playlists (listed below and on My Courses page) are curated collections of content about specific job functions or important subjects.  As you complete various courses or content, you&#39;re invited to share your comments and recommendations with the team!</p><p>For a screencast about basic functionality, click <a href="https://vimeo.com/100743097">EdgeRocket Introduction</a>.</p><p>Questions?  Contact <a href="email:support@edgerocket.co">support@edgerocket.co</a></p>');

insert into users(email, first_name, last_name, account_id, encrypted_password) 
	values('ckk@venturelawadvisors.com', 'Charles', 'Knight', CURRVAL('accounts_id_seq'), '$2a$10$ii/dDmLiNPFA6EbB4x3Di.4YyCnlIvu1Sfd2fEVOvAAUPgmE67lU.');
	-- EdgeFr@@

insert into roles(user_id, name) values(CURRVAL('users_id_seq'),'SA');

insert into playlists(title, mandatory, description, account_id)
	select title, mandatory, description, CURRVAL('accounts_id_seq') from playlists where id=3008;

insert into playlist_items(playlist_id, product_id, rank)
	select CURRVAL('playlists_id_seq'), product_id, rank from playlist_items where playlist_id=3008;

-- ***

insert into accounts(company_name,options,overview) 
	values('Zero Creek', 
		'{"budget_management":false,"survey":true,"discussions":"builtin","recommendations":false,"disable_search":false,"disable_plans":true,"dashboard_demo":false}',
		'<p>EdgeRocket provides access to learning resources -- such as online courses, books and videos -- on business and technical topics.  The playlists (listed below and on My Courses page) are curated collections of content about specific job functions or important subjects.  As you complete various courses or content, you&#39;re invited to share your comments and recommendations with the team!</p><p>For a screencast about basic functionality, click <a href="https://vimeo.com/100743097">EdgeRocket Introduction</a>.</p><p>Questions?  Contact <a href="email:support@edgerocket.co">support@edgerocket.co</a></p>');

insert into users(email, first_name, last_name, account_id, encrypted_password) 
	values('ft@traylor.net', 'Frank', 'Traylor', CURRVAL('accounts_id_seq'), '$2a$10$ii/dDmLiNPFA6EbB4x3Di.4YyCnlIvu1Sfd2fEVOvAAUPgmE67lU.');
	-- EdgeFr@@

insert into roles(user_id, name) values(CURRVAL('users_id_seq'),'SA');

insert into playlists(title, mandatory, description, account_id)
	select title, mandatory, description, CURRVAL('accounts_id_seq') from playlists where id=3008;

insert into playlist_items(playlist_id, product_id, rank)
	select CURRVAL('playlists_id_seq'), product_id, rank from playlist_items where playlist_id=3008;

-- ***

insert into accounts(company_name,options,overview) 
	values('McLaughlin Company', 
		'{"budget_management":false,"survey":true,"discussions":"builtin","recommendations":false,"disable_search":false,"disable_plans":true,"dashboard_demo":false}',
		'<p>EdgeRocket provides access to learning resources -- such as online courses, books and videos -- on business and technical topics.  The playlists (listed below and on My Courses page) are curated collections of content about specific job functions or important subjects.  As you complete various courses or content, you&#39;re invited to share your comments and recommendations with the team!</p><p>For a screencast about basic functionality, click <a href="https://vimeo.com/100743097">EdgeRocket Introduction</a>.</p><p>Questions?  Contact <a href="email:support@edgerocket.co">support@edgerocket.co</a></p>');

insert into users(email, first_name, last_name, account_id, encrypted_password) 
	values('info@petermclaughlin.com', 'Peter', 'McLaughlin', CURRVAL('accounts_id_seq'), '$2a$10$ii/dDmLiNPFA6EbB4x3Di.4YyCnlIvu1Sfd2fEVOvAAUPgmE67lU.');
	-- EdgeFr@@

insert into roles(user_id, name) values(CURRVAL('users_id_seq'),'SA');

insert into playlists(title, mandatory, description, account_id)
	select title, mandatory, description, CURRVAL('accounts_id_seq') from playlists where id=3008;

insert into playlist_items(playlist_id, product_id, rank)
	select CURRVAL('playlists_id_seq'), product_id, rank from playlist_items where playlist_id=3008;
