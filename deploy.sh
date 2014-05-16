git push
git push heroku master-heroku:master
heroku run rake db:schema:load
heroku run rake db:fixtures:load
heroku run rake db:seed
echo 'done'