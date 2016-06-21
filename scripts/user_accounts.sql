select company_name, a.id, email, u.id, first_name, last_name, provider 
from users u left join accounts a on u.account_id=a.id 
where --a.id=191
	email like '%startup%'
	--email like 'katr%'
order by 1, 2, 3;