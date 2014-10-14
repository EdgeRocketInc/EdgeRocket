select u.email, product_id, substring(title from 1 for 10)
from discussions d join users u on u.id=d.user_id
--where title is null
order by created_at desc;