select sign_in_count, email from users 
where sign_in_count > 0
	and lower(email) not like '%admin%' 
	and lower(email) not like '%johnsmith%'
	and lower(email) not like '%dmitriy%'
	and lower(email) not like '%mclaughl%'
	and email not like '%techcorp.com' and email not like '%rocket.co' and email not like 'johnsmith%' and email not like 'admin%' 
order by 1 desc;	