select --mc.status, mc.product_id, u.email 
	first_name || ' ' || last_name || ', ' || substring(p.name from 1 for 40), status
from my_courses mc
	join users u on mc.user_id=u.id
	join products p on mc.product_id=p.id
where mc.status in ('compl','reg')
	and u.account_id=133
order by 1;


\copy (select 	first_name || ' ' || last_name || '|' || substring(p.name from 1 for 50) from my_courses mc join users u on mc.user_id=u.id join products p on mc.product_id=p.id where mc.status in ('compl') and u.account_id=133 order by 1) to '~/Projects/eraseme/courses.txt'