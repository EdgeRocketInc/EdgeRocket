select avg(my_rating) avg_rating, vendor_id, p.name
from my_courses mc join products p on p.id=mc.product_id
where my_rating is not null                         
group by p.name, vendor_id
order by avg_rating desc;


select mc.product_id, u.email
from my_courses mc join users u on u.id=mc.user_id
where my_rating is not null and u.account_id=132
order by 1;


