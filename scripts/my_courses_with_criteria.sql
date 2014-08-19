select status, email 
from my_courses mc join products p on mc.product_id=p.id join users u on u.id=mc.user_id 
	and vendor_id=3 and p.name like '%Cold%' 
order by status;