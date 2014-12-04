select id, 
	substring(p.name from 1 for 20) as name, 
	price, 
	substring(keywords from 1 for 10) as keywords, 
	substring(authors from 1 for 10) as authors, 
	school, 
	manual_entry, 
	duration, 
	substring(description from 1 for 20)
from products p 
where -- lower(p.name) like '%culture%' and
vendor_id=10
--lower(p.name) like '% go%' 
--lower(p.name) like '% go%' or
--lower(p.name) like '%go %'
order by p.name;
