--select count(*)
select id, email, last_sign_in_at, current_sign_in_at 
from users 
where lower(email) not like '%edgerocket%' and lower(email) not like '%techcorp%' and lower(email) not like '%admin%' and lower(email) not like '%johnsmith%' and lower(email) not like '%dmitriyev%' and lower(email) not like '%employee@%'
	--and current_sign_in_at is not null
	and account_id=161
	--and lower(email) like '%serdar%'
order by 3;