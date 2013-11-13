set -e

sudo apt-get -y install makepasswd
zabbixPassword=$(makepasswd --char=10)
mysqlPassword=$(makepasswd --char=10)
echo $zabbixPassword > /root/.zabbixPassword
echo $mysqlPassword > /root/.mysqlPassword

sudo bash <<EOF
echo mysql-server mysql-server/root_password password $mysqlPassword | sudo debconf-set-selections
echo mysql-server mysql-server/root_password_again password $mysqlPassword | sudo debconf-set-selections

echo 'deb http://ppa.launchpad.net/tbfr/zabbix/ubuntu precise main' >> /etc/apt/sources.list.d/zabbix.list
echo 'deb-src http://ppa.launchpad.net/tbfr/zabbix/ubuntu precise main' >> /etc/apt/sources.list.d/zabbix.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C407E17D5F76A32B
apt-get update
apt-get -y install ntp ufw zabbix-server-mysql zabbix-frontend-php zabbix-agent

ufw allow www
ufw allow 10051
ufw --force enable

sed 's/# DBPassword=/DBPassword=$zabbixPassword/' -i /etc/zabbix/zabbix_server.conf

cd /usr/share/zabbix-server-mysql
gunzip *.gz

mysql -u root -p$mysqlPassword -e "create user 'zabbix'@'localhost' identified by '$zabbixPassword';"
mysql -u root -p$mysqlPassword -e "create database zabbix;"
mysql -u root -p$mysqlPassword -e "grant all privileges on zabbix.* to 'zabbix'@'localhost';flush privileges;"
mysql -u zabbix -p$zabbixPassword zabbix < schema.sql
mysql -u zabbix -p$zabbixPassword zabbix < images.sql
mysql -u zabbix -p$zabbixPassword zabbix < data.sql

sed 's/post_max_size = 8M/post_max_size = 16M/' -i /etc/php5/apache2/php.ini
sed 's/max_execution_time = 30/max_execution_time = 300/' -i /etc/php5/apache2/php.ini
sed 's/max_input_time = 60/max_input_time = 600/' -i /etc/php5/apache2/php.ini
sed 's/;date.timezone =/date.timezone = UTC/' -i /etc/php5/apache2/php.ini

cp /usr/share/doc/zabbix-frontend-php/examples/zabbix.conf.php.example /etc/zabbix/zabbix.conf.php
sed 's/zabbix_password/$zabbixPassword/' -i /etc/zabbix/zabbix.conf.php

cp /usr/share/doc/zabbix-frontend-php/examples/apache.conf /etc/apache2/conf.d/zabbix.conf

a2enmod alias
service apache2 restart

sed 's/START=no/START=yes/' -i /etc/default/zabbix-server
service zabbix-server restart
service zabbix-agent restart

EOF