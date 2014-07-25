select mc.status, mc.product_id, u.email from my_courses mc
	join users u on mc.user_id=u.id
where mc.status not in ('reg')
order by 1;