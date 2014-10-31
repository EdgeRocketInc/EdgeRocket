select id, substring(p.name from 1 for 30), keywords
from products p 
where lower(p.name) like '%culture%'
order by p.name;
