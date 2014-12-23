select company_name, a.id, email, u.id, first_name, last_name, provider 
from users u left join accounts a on u.account_id=a.id 
where --a.id=132
	--email like '%goldenalum%'
	email like 'co%'
order by 1, 2, 3;