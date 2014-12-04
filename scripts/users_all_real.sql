select count(*) from users where lower(email) not like '%edgerocket%'  and lower(email) not like '%techcorp%' and lower(email) not like '%admin%' and lower(email) not like '%johnsmith%' and lower(email) not like '%dmitriyev%' and lower(email) not like '%employee@%';


\copy (select email from users where lower(email) not like '%edgerocket%'  and lower(email) not like '%techcorp%' and lower(email) not like '%admin%' and lower(email) not like '%johnsmith%' and lower(email) not like '%dmitriyev%' and lower(email) not like '%employee@%' order by 1) TO 'users_all_real.txt' CSV

\copy (select email from users where account_id=132 and lower(email) not like '%edgerocket%' and lower(email) not like '%techcorp%' and lower(email) not like '%admin%' and lower(email) not like '%johnsmith%' and lower(email) not like '%dmitriyev%' and lower(email) not like '%employee@%' order by 1) TO 'users_a20_all.txt' CSV

\copy (select email from users where account_id<>132 and lower(email) not like '%edgerocket%' and lower(email) not like '%techcorp%' and lower(email) not like '%admin%' and lower(email) not like '%johnsmith%' and lower(email) not like '%dmitriyev%' and lower(email) not like '%employee@%' order by 1) TO 'users_all_minus_a20.txt' CSV
