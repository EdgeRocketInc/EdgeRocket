select email, mc.product_id, mc.my_rating --, d.product_id, substring(d.title from 1 for 20)
from users u join my_courses mc on u.id=mc.user_id 
	left join discussions d on mc.product_id=d.product_id and mc.user_id=d.user_id
where mc.status in ('compl') and 
--email like '%goldenalum%'
	email not like '%techcorp.com' and email not like '%rocket.co' and email not like 'admin@%' 
	and d.product_id is null and mc.my_rating is null
order by 1;
