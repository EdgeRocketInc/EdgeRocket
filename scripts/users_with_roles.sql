select a.id, u.id, r.id, company_name, email, first_name, last_name, r.name
from users u left join accounts a on u.account_id=a.id 
	join roles r on r.user_id=u.id
order by 1,2;