-- select email, mc.status, count(mc.id)
select first_name || ' ' || last_name, pl.id, pl.title
from 
	users u left join playlists_users pu on u.id=pu.user_id
	left join playlists pl on pl.id=pu.playlist_id
where 
	email not like '%techcorp.com' and email not like '%rocket.co' and email not like 'johnsmith%' and email not like 'admin%' 
	and u.account_id=133
order by first_name, last_name;
