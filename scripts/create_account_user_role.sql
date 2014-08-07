insert into accounts(company_name,options,overview) 
	values('FI Denver Boulder" ', 
		'{"budget_management":false,"survey":true,"discussions":"builtin","recommendations":false,"disable_search":false,"disable_plans":true,"dashboard_demo":false}',
		'<p>EdgeRocket provides access to learning resources -- such as online courses, articles and videos -- on business and technical topics.  Quick tips:</p><ol><li>Go to <a href="/search">Search</a> page to search for learning content.</li><li>Once you identify a course or article of interest on the <a href="/search">Search</a> page, click and select "Add to Wishlist," and it will appear in your Wishlist on the <a href="/my_courses">My Courses</a> page.</li><li>As you complete various courses or content, you&#39;re invited to share comments and recommendations (click "C" for Completed next to the item on <a href="/my_courses">My Courses</a> page).</li><li>The playlists (listed below and detailed on <a href="/my_courses">My Courses</a> page) are curated collections of content about specific job functions or important topics. A user with an administrator role can create playlists under <a href="/playlists">Manage>Playlists</a>.</li></ol><p>For a screencast about basic functionality, click <a href="https://vimeo.com/100743097" target="_blank">EdgeRocket Introduction</a>.</p><p>Questions? Contact <a href="mailto:support@edgerocket.co">support@edgerocket.co</a></p>');

-- FIAlumn!
insert into users(email, first_name, last_name, account_id, encrypted_password) 
	values('aleksey.dmitriyev@gmail.com', 'Alexey', 'Dmitriyev', CURRVAL('accounts_id_seq'), '$2a$10$DjLnJ1U.hqpUn07u8LUjcecZVex9Y4jZiqoVb5WVG.9IH3JXlglmK');
insert into roles(user_id, name) values(CURRVAL('users_id_seq'),'Admin');

insert into users(email, first_name, last_name, account_id, encrypted_password) 
	values('peter.mclaughlin00@gmail.com', 'Peter', 'McLaughlin', CURRVAL('accounts_id_seq'), '$2a$10$DjLnJ1U.hqpUn07u8LUjcecZVex9Y4jZiqoVb5WVG.9IH3JXlglmK');
insert into roles(user_id, name) values(CURRVAL('users_id_seq'),'Admin');

insert into users(email, first_name, last_name, account_id, encrypted_password) 
	values('amichels.co@gmail.com', 'Andrea', 'Michels', CURRVAL('accounts_id_seq'), '$2a$10$DjLnJ1U.hqpUn07u8LUjcecZVex9Y4jZiqoVb5WVG.9IH3JXlglmK');
insert into roles(user_id, name) values(CURRVAL('users_id_seq'),'Admin');

insert into users(email, first_name, last_name, account_id, encrypted_password) 
	values('amichels.co@gmail.com', 'Andrea', 'Michels', CURRVAL('accounts_id_seq'), '$2a$10$DjLnJ1U.hqpUn07u8LUjcecZVex9Y4jZiqoVb5WVG.9IH3JXlglmK');
insert into roles(user_id, name) values(CURRVAL('users_id_seq'),'Admin');

insert into users(email, first_name, last_name, account_id, encrypted_password) 
	values('rsmith@eomedia.com', 'Ryan', 'Smith', CURRVAL('accounts_id_seq'), '$2a$10$DjLnJ1U.hqpUn07u8LUjcecZVex9Y4jZiqoVb5WVG.9IH3JXlglmK');
insert into roles(user_id, name) values(CURRVAL('users_id_seq'),'Admin');

insert into users(email, first_name, last_name, account_id, encrypted_password) 
	values('depewally@aol.com', 'Missy', 'DePew', CURRVAL('accounts_id_seq'), '$2a$10$DjLnJ1U.hqpUn07u8LUjcecZVex9Y4jZiqoVb5WVG.9IH3JXlglmK');
insert into roles(user_id, name) values(CURRVAL('users_id_seq'),'Admin');

insert into users(email, first_name, last_name, account_id, encrypted_password) 
	values('stefan.hoglund@gmail.com', 'Stefan', 'Hoglund', CURRVAL('accounts_id_seq'), '$2a$10$DjLnJ1U.hqpUn07u8LUjcecZVex9Y4jZiqoVb5WVG.9IH3JXlglmK');
insert into roles(user_id, name) values(CURRVAL('users_id_seq'),'Admin');

insert into users(email, first_name, last_name, account_id, encrypted_password) 
	values('astruthers@infogen.net', 'Alan', 'Struthers', CURRVAL('accounts_id_seq'), '$2a$10$DjLnJ1U.hqpUn07u8LUjcecZVex9Y4jZiqoVb5WVG.9IH3JXlglmK');
insert into roles(user_id, name) values(CURRVAL('users_id_seq'),'Admin');

insert into users(email, first_name, last_name, account_id, encrypted_password) 
	values('josh@myfitoption.com', 'Josh', 'Mollohan', CURRVAL('accounts_id_seq'), '$2a$10$DjLnJ1U.hqpUn07u8LUjcecZVex9Y4jZiqoVb5WVG.9IH3JXlglmK');
insert into roles(user_id, name) values(CURRVAL('users_id_seq'),'Admin');

insert into users(email, first_name, last_name, account_id, encrypted_password) 
	values('sandoval.isaac@gmail.com', 'Isaac', 'Sandoval', CURRVAL('accounts_id_seq'), '$2a$10$DjLnJ1U.hqpUn07u8LUjcecZVex9Y4jZiqoVb5WVG.9IH3JXlglmK');
insert into roles(user_id, name) values(CURRVAL('users_id_seq'),'Admin');

insert into users(email, first_name, last_name, account_id, encrypted_password) 
	values('mnlindy34@gmail.com', 'Erik', 'Lindstrom', CURRVAL('accounts_id_seq'), '$2a$10$DjLnJ1U.hqpUn07u8LUjcecZVex9Y4jZiqoVb5WVG.9IH3JXlglmK');
insert into roles(user_id, name) values(CURRVAL('users_id_seq'),'Admin');

insert into users(email, first_name, last_name, account_id, encrypted_password) 
	values('leong.jo@gmail.com', 'Josh', 'Leong', CURRVAL('accounts_id_seq'), '$2a$10$DjLnJ1U.hqpUn07u8LUjcecZVex9Y4jZiqoVb5WVG.9IH3JXlglmK');
insert into roles(user_id, name) values(CURRVAL('users_id_seq'),'Admin');

insert into users(email, first_name, last_name, account_id, encrypted_password) 
	values('brad@intelivideo.com', 'Brad', 'Brown', CURRVAL('accounts_id_seq'), '$2a$10$DjLnJ1U.hqpUn07u8LUjcecZVex9Y4jZiqoVb5WVG.9IH3JXlglmK');
insert into roles(user_id, name) values(CURRVAL('users_id_seq'),'Admin');

insert into users(email, first_name, last_name, account_id, encrypted_password) 
	values('ft@traylor.net', 'Frank', 'Traylor', CURRVAL('accounts_id_seq'), '$2a$10$DjLnJ1U.hqpUn07u8LUjcecZVex9Y4jZiqoVb5WVG.9IH3JXlglmK');
insert into roles(user_id, name) values(CURRVAL('users_id_seq'),'Admin');




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
