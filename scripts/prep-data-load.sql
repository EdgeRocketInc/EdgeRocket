-- KEEP products that are used

select p.id, name, origin from products p 
where vendor_id = 11
and manual_entry='f'
and (
	id in (select product_id from discussions where product_id=p.id)
	or id in (select product_id from my_courses where product_id=p.id)
	or id in (select product_id id from playlist_items where product_id=p.id)
	or id in (select product_id id from recommendations where product_id=p.id)
);


-- DELETE products that are NOT used
DELETE
--select count(*)
from products p 
where vendor_id = 11
and manual_entry='f'
and (
	id not in (select product_id from discussions where product_id=p.id)
	and id not in (select product_id from my_courses where product_id=p.id)
	and id not in (select product_id id from playlist_items where product_id=p.id)
	and id not in (select product_id id from recommendations where product_id=p.id)
);
