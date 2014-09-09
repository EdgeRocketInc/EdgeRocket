Use this query to identify and delete prodcut records before inserting new ones:

select p.id, name from products p 
where vendor_id = 10
-- and manual_entry='f'
and (
	id not in (select product_id from discussions where product_id=p.id)
	and id not in (select product_id from my_courses where product_id=p.id)
	and id not in (select product_id id from playlist_items where product_id=p.id)
)
