--select email, mc.status, count(mc.id)
select first_name || ' ' || last_name, pl.id, pl.title
from 
	users u join playlists_users pu on u.id=pu.user_id
	join playlists pl on pl.id=pu.playlist_id
where 
	email not like '%techcorp.com' and email not like '%rocket.co' and email not like 'johnsmith%' and email not like 'admin%' 
	and u.account_id=176
order by first_name, last_name;
