select a.company_name, count(pl.id)
from accounts a left join playlists pl  on a.id=pl.account_id 
--join playlist_items pi on pi.playlist_id=pl.id join products p on p.id=pi.product_id 
group by a.company_name
order by 2, 1;
