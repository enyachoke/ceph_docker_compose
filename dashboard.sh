#!/bin/bash
set -x
S3_HOST=""
if [ -z "$1" ]
then
      echo "S3_HOST is empty you need to set it"
      exit 1
fi

docker-compose exec mon1 ceph mgr module enable dashboard
docker-compose exec mon1 ceph dashboard create-self-signed-cert
docker-compose exec mon1 ceph mgr module disable dashboard
docker-compose exec mon1 ceph mgr module enable dashboard
docker-compose exec mon1 ceph config set mgr mgr/dashboard/server_addr mgr
docker-compose exec mon1 ceph config set mgr mgr/dashboard/server_port 8443
docker-compose exec mon1 ceph mgr services
docker-compose exec mon1 ceph dashboard set-login-credentials admin 123456
docker-compose exec mon1 radosgw-admin user create --uid=1000 --display-name=user --system
docker-compose exec mon1 radosgw-admin user info --uid=1000
access_key=$(docker-compose exec mon1 radosgw-admin user info --uid=1000 | grep access_key | awk '{print $2}' | sed 's/"//g'|sed 's/,//g')
secret_key=$(docker-compose exec mon1 radosgw-admin user info --uid=1000 | grep secret_key | awk '{print $2}' | sed 's/"//g'|sed 's/,//g')
echo $access_key
echo $secret_key


docker-compose exec mon1 ceph dashboard set-rgw-api-user-id 1000

docker-compose exec mon1 ceph dashboard set-rgw-api-port 8080
docker-compose exec mon1 ceph dashboard set-rgw-api-host $S3_HOST
docker-compose exec mon1 ceph dashboard set-rgw-api-scheme http
docker-compose exec mon1 ceph dashboard set-rgw-api-access-key $access_key
docker-compose exec mon1 ceph dashboard set-rgw-api-secret-key $secret_key
docker-compose exec mon1 ceph dashboard set-rgw-api-ssl-verify False

docker-compose exec mon1 ceph dashboard get-rgw-api-port
docker-compose exec mon1 ceph dashboard get-rgw-api-host
docker-compose exec mon1 ceph dashboard get-rgw-api-access-key
docker-compose exec mon1 ceph dashboard get-rgw-api-secret-key
docker-compose exec mon1 ceph dashboard get-rgw-api-scheme
docker-compose exec mon1 ceph dashboard get-rgw-api-ssl-verify
