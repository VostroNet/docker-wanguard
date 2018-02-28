#!/bin/bash

if [ -n "$MYSQL_PASSWORD" ]; then
  echo $MYSQL_PASSWORD > /opt/andrisoft/etc/dbpass.conf
fi

if [ -n "$MYSQL_HOST" ]; then
  echo $MYSQL_HOST > /opt/andrisoft/etc/dbhost.conf
fi
echo "" > /var/log/messages

/opt/andrisoft/bin/WANsupervisor
# hack to keep the container running? want to actually get logs
tail -f /var/log/messages