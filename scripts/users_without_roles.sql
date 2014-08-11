select company_name, email, first_name, last_name, r.name
from users u left join accounts a on u.account_id=a.id 
	left join roles r on r.user_id=u.id
where r.id is null
order by 1,2;