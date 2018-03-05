cd console
docker build -t wanguard-console .
cd ..

cd supervisor
docker build -t wanguard-supervisor .
cd ..

# docker stop wanguard-mariadb
docker stop wanguard-console wanguard-supervisor
# docker rm wanguard-mariadb
docker rm wanguard-console wanguard-supervisor


# docker run -d --name wanguard-mariadb \
#   -e MYSQL_ROOT_PASSWORD=my-secret-pw \
#   -v "$(pwd)/db:/var/lib/mysql" \
#   mariadb:la5test --max-allowed-packet=64M --max-connections=1000 --open-files-limit=5000 --skip-name-resolve

docker run -d --name wanguard-console \
  --link wanguard-mariadb:mariadb \
  -p 8889:80 \
  -e MYSQL_HOST=mariadb \
  -e MYSQL_PASSWORD=testing123 \
  -e TZ=Australia/Brisbane \
  wanguard-console

docker exec -it wanguard-console /install.sh

docker restart wanguard-console
docker run -d --name wanguard-supervisor \
  --link wanguard-mariadb:mariadb \
  -e MYSQL_HOST=mariadb \
  -e MYSQL_PASSWORD=testing123 \
  -e TZ=Australia/Brisbane \
  wanguard-supervisor

# docker logs wanguard-console

docker restart wanguard-console

