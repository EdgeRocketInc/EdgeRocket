select company_name, count(u.id) 
from users u left join accounts a on u.account_id=a.id 
group by company_name
order by 2,1;