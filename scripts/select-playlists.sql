select a.company_name, pl.title, pl.id
from accounts a left join playlists pl on a.id=pl.account_id
where account_id=142
order by 1, 2;
