select u.email, product_id, title
from discussions d join users u on u.id=d.user_id
where length(title) > 0
order by created_at desc;