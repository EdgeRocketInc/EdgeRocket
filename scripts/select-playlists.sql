select a.company_name, pl.title
from accounts a left join playlists pl on a.id=pl.account_id
order by 1, 2;
