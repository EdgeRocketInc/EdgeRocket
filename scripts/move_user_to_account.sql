select id,email,account_id from users where account_id=236;
select * from playlists where account_id=236;
select * from products where account_id=236;
select * from playlists_users pu join users u on u.id=pu.user_id where account_id=236;

update users set account_id=235 where id=444;