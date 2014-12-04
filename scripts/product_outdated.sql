select vendor_id, v.name, max(p.created_at) max_created, min(p.created_at), count(p.id)
from products p join vendors v on v.id=p.vendor_id
where manual_entry='f' 
group by vendor_id, v.name
order by max_created;