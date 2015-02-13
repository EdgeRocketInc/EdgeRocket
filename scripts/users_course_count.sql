select email, count(mcc.id)
--select first_name || ' ' || last_name || ',' || count(mcc.id)
from 
	users u left join (select * from my_courses where status<>'compl') mcc on u.id=mcc.user_id 
	--left join (select * from my_courses where status='reg') mca on u.id=mca.user_id
where --mcc.status in ('compl') or mca.status in ('reg') 
	--email like '%goldenalum%'
	email not like '%techcorp.com' and email not like '%rocket.co' and email not like 'johnsmith%' and email not like 'admin%' 
	and account_id=132
group by email
having count(mcc.id) > 0
order by  2; --first_name, last_name;


--- no group

-- select email, mc.status, count(mc.id)
select first_name || ' ' || last_name, mcc.id --, mca.id
from 
	--users u join (select * from my_courses where status ='compl') mcc on u.id=mcc.user_id 
	users u join my_courses mcc on u.id=mcc.user_id 
	--join (select * from my_courses where status='reg') mca on u.id=mca.user_id
where --mcc.status in ('compl') or mca.status in ('reg') 
	--email like '%goldenalum%'
	--email not like '%techcorp.com' and email not like '%rocket.co' and email not like 'johnsmith%' and email not like 'admin%' 
	lower(email) not like '%edgerocket%' and lower(email) not like '%techcorp%' and lower(email) not like '%admin%' and lower(email) not like '%johnsmith%' and lower(email) not like '%dmitriyev%' and lower(email) not like '%employee@%'
	and account_id=191
order by first_name, last_name;
