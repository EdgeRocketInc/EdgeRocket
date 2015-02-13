select d.id, u.account_id, product_id, substring(title from 1 for 10), created_at
from discussions d join users u on u.id=d.user_id
where 
	email not like '%techcorp.com' and email not like '%rocket.co' and email not like 'johnsmith%' and email not like 'admin%' 
--email like '%goldena%'
--and account_id=132
--title is null
order by created_at desc;

-- full text for digest

select p.id, p.name --, title
from discussions d join users u on u.id=d.user_id
	join products p on p.id=d.product_id
where email like '%goldena%'
--title is null
order by 1;
