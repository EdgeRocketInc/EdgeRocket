select count(*), v.name
from vendors v join products p on v.id=p.vendor_id 
group by p.vendor_id, v.name, v.id
order by 1 desc;