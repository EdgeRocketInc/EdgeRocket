select distinct email
from users u join surveys s on u.id=s.user_id
where lower(email) not like '%admin%' 
	and lower(email) not like '%johnsmith%'
	and email not like '%techcorp.com' and email not like '%rocket.co' and email not like 'johnsmith%' and email not like 'admin%' 
	and account_id=132
order by 1;

-- no surveys

select email 
from users u 
where u.id not in (select user_id from surveys)
order by 1;
