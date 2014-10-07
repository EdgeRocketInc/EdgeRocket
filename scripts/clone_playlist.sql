insert into playlists(title, mandatory, description, account_id)
	select title, mandatory, description, 140 from playlists where id=3008;
insert into playlist_items(playlist_id, product_id, rank)
	select CURRVAL('playlists_id_seq'), product_id, rank from playlist_items where playlist_id=3008;

insert into playlists(title, mandatory, description, account_id)
	select title, mandatory, description, 140 from playlists where id=3023;
insert into playlist_items(playlist_id, product_id, rank)
	select CURRVAL('playlists_id_seq'), product_id, rank from playlist_items where playlist_id=3023;
