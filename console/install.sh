#!/bin/bash

##################################################################
#                                                                #
#     Andrisoft Wanguard 6.3 All rights reserved.                #
#                                                                #
##################################################################

# do NOT run this on upgrades. It is only required for the initial installation

if [ -z $WANGUARD_INSTALL_DB_USER ]; then
  if [ -f /opt/andrisoft/doc/license.txt ]; then
    more /opt/andrisoft/doc/license.txt
  fi
fi

echo
echo

mydb_create=0
while (( !$mydb_create ))
do
  username="$WANGUARD_INSTALL_DB_USER"
  [ -z "$username" ] && read -p "Type username for access to the MySQL database [root]:" username
  password="$WANGUARD_INSTALL_DB_PASS"
  [ -z "$password" ] && read -p "Type password for access to the MySQL database []:" password
  # server="$WANGUARD_INSTALL_DB_SERVER"
  # [ -z "$host" ] && read -p "Type the host for access to the MySQL database []:" host

  # MYSQLOPTION=" -h 127.0.0.1"

  if [ -z "$username" ]; then
    username="root"
  fi
  MYSQLOPTION="$MYSQLOPTION -u $username"

  if [ -n "$password" ]; then
    MYSQLOPTION="$MYSQLOPTION --password=$password"
  fi
  # if [ -n "$host" ]; then
  #   MYSQLOPTION="$MYSQLOPTION -h $host"
  # fi
  echo $MYSQLOPTION
  MYSQL="mysql $MYSQLOPTION"
  echo "CREATE DATABASE andrisoft;" | $MYSQL -s
  mydb_create=$(( ! $? ))
done

echo "Creating a new database named \"andrisoft\".. please be patient"
$MYSQL andrisoft < /opt/andrisoft/sql/andrisoft.sql
$MYSQL andrisoft < /opt/andrisoft/sql/as_numbers.sql
echo "Done creating the database"

wgpass_create=0
HOSTNAME=`hostname -s`
while (( !$wgpass_create ))
do
  wgpass="$WANGUARD_CONSOLE_DB_PASS"
  [ -z "$wgpass" ] && read -p "Type new password for Console MySQL access []:" wgpass
  if [ -n "$wgpass" ]; then
    echo "CREATE USER 'andrisoft'@'localhost' IDENTIFIED BY '$wgpass';" | $MYSQL -s
    echo "GRANT ALL ON andrisoft.* TO andrisoft@'localhost';" | $MYSQL -s
    if [ "$HOSTNAME" != "localhost" ]; then
      echo "CREATE USER 'andrisoft'@'$HOSTNAME' IDENTIFIED BY '$wgpass';" | $MYSQL -s
      echo "GRANT ALL ON andrisoft.* TO andrisoft@'$HOSTNAME';" | $MYSQL -s
    fi
    echo "CREATE USER 'andrisoft'@'%' IDENTIFIED BY '$wgpass';" | $MYSQL -s
    echo "GRANT ALL ON andrisoft.* TO andrisoft@'%';" | $MYSQL -s
    wgpass_create=$(( ! $? ))
    echo "FLUSH PRIVILEGES;" | $MYSQL -s
    echo $wgpass > /opt/andrisoft/etc/dbpass.conf
  else
    echo "You must supply a password";
  fi
done
# systemctl restart WANsupervisor