insert into accounts(company_name,options,overview) 
	values('Anil Kumar', 
		'{"budget_management":false,"survey":true,"discussions":"builtin","recommendations":false,"disable_search":false,"disable_plans":true,"dashboard_demo":false}',
		'<p>EdgeRocket provides access to learning resources -- such as online courses, articles and videos -- on business and technical topics.  Quick tips:</p><ol><li>Go to <a href="/search">Search</a> page to search for learning content.</li><li>Once you identify a course or article of interest on the <a href="/search">Search</a> page, click and select "Add to Wishlist," and it will appear in your Wishlist on the <a href="/my_courses">My Courses</a> page.</li><li>As you complete various courses or content, you&#39;re invited to share comments and recommendations (click "C" for Completed next to the item on <a href="/my_courses">My Courses</a> page).</li><li>The playlists (listed below and detailed on <a href="/my_courses">My Courses</a> page) are curated collections of content about specific job functions or important topics. A user with an administrator role can create playlists under <a href="/playlists">Manage>Playlists</a>.</li></ol><p>For a screencast about basic functionality, click <a href="https://vimeo.com/100743097" target="_blank">EdgeRocket Introduction</a>.</p><p>Questions? Contact <a href="mailto:support@edgerocket.co">support@edgerocket.co</a></p>');

insert into users(email, first_name, last_name, account_id, encrypted_password) 
	values('anil.kumar@gmail.com', 'Anil', 'Kumar', CURRVAL('accounts_id_seq'), '$2a$10$ii/dDmLiNPFA6EbB4x3Di.4YyCnlIvu1Sfd2fEVOvAAUPgmE67lU.');
	-- EdgeFr@@

insert into roles(user_id, name) values(CURRVAL('users_id_seq'),'SA');

insert into playlists(title, mandatory, description, account_id)
	select title, mandatory, description, CURRVAL('accounts_id_seq') from playlists where id=3008;
insert into playlist_items(playlist_id, product_id, rank)
	select CURRVAL('playlists_id_seq'), product_id, rank from playlist_items where playlist_id=3008;

insert into playlists(title, mandatory, description, account_id)
	select title, mandatory, description, CURRVAL('accounts_id_seq') from playlists where id=3009;
insert into playlist_items(playlist_id, product_id, rank)
	select CURRVAL('playlists_id_seq'), product_id, rank from playlist_items where playlist_id=3009;

insert into playlists(title, mandatory, description, account_id)
	select title, mandatory, description, CURRVAL('accounts_id_seq') from playlists where id=3023;
insert into playlist_items(playlist_id, product_id, rank)
	select CURRVAL('playlists_id_seq'), product_id, rank from playlist_items where playlist_id=3023;

--------

insert into accounts(company_name,options,overview) 
	values('Jignesh Patel', 
		'{"budget_management":false,"survey":true,"discussions":"builtin","recommendations":false,"disable_search":false,"disable_plans":true,"dashboard_demo":false}',
		'<p>EdgeRocket provides access to learning resources -- such as online courses, articles and videos -- on business and technical topics.  Quick tips:</p><ol><li>Go to <a href="/search">Search</a> page to search for learning content.</li><li>Once you identify a course or article of interest on the <a href="/search">Search</a> page, click and select "Add to Wishlist," and it will appear in your Wishlist on the <a href="/my_courses">My Courses</a> page.</li><li>As you complete various courses or content, you&#39;re invited to share comments and recommendations (click "C" for Completed next to the item on <a href="/my_courses">My Courses</a> page).</li><li>The playlists (listed below and detailed on <a href="/my_courses">My Courses</a> page) are curated collections of content about specific job functions or important topics. A user with an administrator role can create playlists under <a href="/playlists">Manage>Playlists</a>.</li></ol><p>For a screencast about basic functionality, click <a href="https://vimeo.com/100743097" target="_blank">EdgeRocket Introduction</a>.</p><p>Questions? Contact <a href="mailto:support@edgerocket.co">support@edgerocket.co</a></p>');

insert into users(email, first_name, last_name, account_id, encrypted_password) 
	values('jipatel@gmail.com', 'Jignesh', 'Patel', CURRVAL('accounts_id_seq'), '$2a$10$ii/dDmLiNPFA6EbB4x3Di.4YyCnlIvu1Sfd2fEVOvAAUPgmE67lU.');
	-- EdgeFr@@

insert into roles(user_id, name) values(CURRVAL('users_id_seq'),'SA');

insert into playlists(title, mandatory, description, account_id)
	select title, mandatory, description, CURRVAL('accounts_id_seq') from playlists where id=3008;
insert into playlist_items(playlist_id, product_id, rank)
	select CURRVAL('playlists_id_seq'), product_id, rank from playlist_items where playlist_id=3008;

insert into playlists(title, mandatory, description, account_id)
	select title, mandatory, description, CURRVAL('accounts_id_seq') from playlists where id=3009;
insert into playlist_items(playlist_id, product_id, rank)
	select CURRVAL('playlists_id_seq'), product_id, rank from playlist_items where playlist_id=3009;

insert into playlists(title, mandatory, description, account_id)
	select title, mandatory, description, CURRVAL('accounts_id_seq') from playlists where id=3023;
insert into playlist_items(playlist_id, product_id, rank)
	select CURRVAL('playlists_id_seq'), product_id, rank from playlist_items where playlist_id=3023;

--------

insert into accounts(company_name,options,overview) 
	values('DawaBI', 
		'{"budget_management":false,"survey":true,"discussions":"builtin","recommendations":false,"disable_search":false,"disable_plans":true,"dashboard_demo":false}',
		'<p>EdgeRocket provides access to learning resources -- such as online courses, articles and videos -- on business and technical topics.  Quick tips:</p><ol><li>Go to <a href="/search">Search</a> page to search for learning content.</li><li>Once you identify a course or article of interest on the <a href="/search">Search</a> page, click and select "Add to Wishlist," and it will appear in your Wishlist on the <a href="/my_courses">My Courses</a> page.</li><li>As you complete various courses or content, you&#39;re invited to share comments and recommendations (click "C" for Completed next to the item on <a href="/my_courses">My Courses</a> page).</li><li>The playlists (listed below and detailed on <a href="/my_courses">My Courses</a> page) are curated collections of content about specific job functions or important topics. A user with an administrator role can create playlists under <a href="/playlists">Manage>Playlists</a>.</li></ol><p>For a screencast about basic functionality, click <a href="https://vimeo.com/100743097" target="_blank">EdgeRocket Introduction</a>.</p><p>Questions? Contact <a href="mailto:support@edgerocket.co">support@edgerocket.co</a></p>');

insert into users(email, first_name, last_name, account_id, encrypted_password) 
	values('mbeacom@dawabi.com', 'Marc', 'Beacom', CURRVAL('accounts_id_seq'), '$2a$10$ii/dDmLiNPFA6EbB4x3Di.4YyCnlIvu1Sfd2fEVOvAAUPgmE67lU.');
	-- EdgeFr@@

insert into roles(user_id, name) values(CURRVAL('users_id_seq'),'SA');

insert into playlists(title, mandatory, description, account_id)
	select title, mandatory, description, CURRVAL('accounts_id_seq') from playlists where id=3008;
insert into playlist_items(playlist_id, product_id, rank)
	select CURRVAL('playlists_id_seq'), product_id, rank from playlist_items where playlist_id=3008;

insert into playlists(title, mandatory, description, account_id)
	select title, mandatory, description, CURRVAL('accounts_id_seq') from playlists where id=3009;
insert into playlist_items(playlist_id, product_id, rank)
	select CURRVAL('playlists_id_seq'), product_id, rank from playlist_items where playlist_id=3009;

insert into playlists(title, mandatory, description, account_id)
	select title, mandatory, description, CURRVAL('accounts_id_seq') from playlists where id=3023;
insert into playlist_items(playlist_id, product_id, rank)
	select CURRVAL('playlists_id_seq'), product_id, rank from playlist_items where playlist_id=3023;
