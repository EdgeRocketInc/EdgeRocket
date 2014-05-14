git push
git push heroku heroku:master
heroku run rake db:schema:load
heroku run rake db:fixtures:load
heroku run rake db:seed
echo 'done'
 
 
