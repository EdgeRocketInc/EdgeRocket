select a.company_name, pl.id, pl.title, p.id, p.name
from accounts a left join playlists pl  on a.id=pl.account_id 
	join playlist_items pi on pi.playlist_id=pl.id 
	join products p on p.id=pi.product_id 
where pl.id=3221
order by 1, 2, 3;
