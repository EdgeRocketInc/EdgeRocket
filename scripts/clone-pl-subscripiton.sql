-- clone pl subscripiton
insert into playlists_users(playlist_id, user_id)
select 3104, id from users where account_id=133 and id not in (select user_id from playlists_users where playlist_id=3104);

-- clone pl subscription items
insert into my_courses 	(user_id,
    product_id,
    created_at,
    updated_at,
    status,    
    assigned_by,
    completion_date,
    percent_complete,
    my_rating)

select  id ,
	14826,
	'2014-10-24',
	'2014-10-24',
	'reg',
	'Self',
	null,
	0.0, 
	null
from users where account_id=133 and id not in (187,189,214,215);


select user_id, email, product_id from my_courses mc join users u on mc.user_id=u.id
where product_id=15680;

delete from my_courses where product_id=15680;