 select a.company_name, pl.title, p.name 
 	from accounts a 
 		left join playlists pl
 		left join playlists_products pp 
 		join products p 
 			on pl.id=pp.playlist_id and pp.product_id=p.id 
 order by 1, 2, 3;