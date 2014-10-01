select company_name, email, first_name, last_name, provider 
from users u left join accounts a on u.account_id=a.id 
order by 1,2;