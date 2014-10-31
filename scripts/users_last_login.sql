select id, email, last_sign_in_at, current_sign_in_at 
from users 
where lower(email) not like '%edgerocket%' and lower(email) not like '%techcorp%'
order by 3;