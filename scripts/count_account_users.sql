	select company_name, max(email), count(u.id) 
	from users u left join accounts a on u.account_id=a.id 
	group by company_name
	order by 3,1;