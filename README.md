# vostro/wanguard

## Introduction

Andrisoft Wanguard is an award-winning enterprise-grade software which delivers to NOC, IT and Security teams the functionality needed for effective monitoring and protection of large WAN networks against volumetric attacks.

https://www.andrisoft.com/software/wanguard

## Deployment

```bash

# docker stop wanguard-mariadb
# docker stop wanguard-console wanguard-supervisor
# docker rm wanguard-mariadb
# docker rm wanguard-console wanguard-supervisor

docker run -d --name wanguard-mariadb \
  -e MYSQL_ROOT_PASSWORD=my-secret-pw \
  -v /my/own/datadir:/var/lib/mysql \
  mariadb:latest --max-allowed-packet=64M --max-connections=1000 --open-files-limit=5000 --skip-name-resolve

docker run -d --name wanguard-console \
  --link wanguard-mariadb:mariadb \
  -p 8889:80 \
  -e MYSQL_HOST=mariadb \
  -e MYSQL_PASSWORD=testing123 \
  -e TZ=Australia/Brisbane \
  vostro/wanguard:console

docker exec -it wanguard-console /install.sh

docker run -d --name wanguard-supervisor \
  --net=host \
  -e MYSQL_HOST=mariadb \
  -e MYSQL_PASSWORD=testing123 \
  -e TZ=Australia/Brisbane \
  vostro/wanguard:supervisor

docker restart wanguard-console

```
