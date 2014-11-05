select id, substring(p.name from 1 for 20), price, keywords, authors, manual_entry, duration, substring(description from 1 for 20)
from products p 
where -- lower(p.name) like '%culture%' and
 vendor_id=11
order by p.name;
