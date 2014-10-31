	select s.id, s.key_name,r.product_id, substring(p.name from 1 for 20), p.vendor_id
	from recommendations r right join skills s on r.skill_id=s.id
		join products p on p.id=r.product_id
	order by s.key_name;