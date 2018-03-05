#!/bin/bash
if [ -n "$MYSQL_PASSWORD" ]; then
  echo $MYSQL_PASSWORD > /opt/andrisoft/etc/dbpass.conf
fi

if [ -n "$MYSQL_HOST" ]; then
  echo $MYSQL_HOST > /opt/andrisoft/etc/dbhost.conf
fi

mysqlhost="$MYSQL_HOST"
if [ -z "$mysqlhost" ]; then
  mysqlhost="127.0.0.1"
fi

sed -i "s/^;date.timezone =$/date.timezone = \"${TZ//\//\\/}\"/" /etc/php.ini

socat UNIX-LISTEN:/var/lib/mysql/mysql.sock,fork,reuseaddr,unlink-early,user=mysql,group=mysql,mode=777 "TCP:$mysqlhost:3306" &

/opt/andrisoft/bin/WANsupervisor &

rm -Rf /run/httpd/*
# Apache gets grumpy about PID files pre-existing
# rm -f /usr/local/apache2/logs/httpd.pid

exec httpd -DFOREGROUND
# #/usr/sbin/init