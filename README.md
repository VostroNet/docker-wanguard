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
  mariadb:latest

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
