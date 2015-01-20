logger START EMAIL REMINDER JOB

source ~/.bash_profile
source ~/.bashrc

PATH=$PATH:/home/alexey_edgerocket_co/.rvm/gems/ruby-2.1.4/bin:/home/alexey_edgerocket_co/.rvm/gems/ruby-2.1.4@global/bin:/home/alexey_edgerocket_co/.rvm/rubies/ruby-2.1.4/bin:/home/alexey_edgerocket_co/.rvm/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/alexey_edgerocket_co/.local/bin:/home/alexey_edgerocket_co/bin

export GEM_PATH=/home/alexey_edgerocket_co/.rvm/gems/ruby-2.1.4:/home/alexey_edgerocket_co/.rvm/gems/ruby-2.1.4@global

cd EdgeRocket/master/services/email_reminder
date -u > er-email.log
env >> er-email.log
pwd >> er-email.log
ruby -v >> er-email.log
ruby main.rb -c ../config/config-production.yaml >> er-email.log
#/home/alexey_edgerocket_co/.rvm/rubies/ruby-2.1.4/bin/ruby /home/alexey_edgerocket_co/EdgeRocket/master/services/email_reminder/main.rb -c /home/alexey_edgerocket_co/EdgeRocket/master/services/config/config-production.yaml >> er-email.log
# -c ../config/config-production.yaml
logger DONE EMAIL REMINDER ERR = $?
