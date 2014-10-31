select d.id, u.email, product_id, substring(title from 1 for 10)
from discussions d join users u on u.id=d.user_id
where email like '%techcorp%'
--title is null
order by created_at desc;