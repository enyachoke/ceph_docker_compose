#!/bin/bash
set -x
source .env 
docker network create --driver bridge --subnet=${MON1_CEPH_PUBLIC_NETWORK} ceph-cluster-net
docker compose up -d mon1 mgr
sudo chmod 777 ceph/ceph/ceph.conf
sudo cat conf >> ceph/ceph/ceph.conf
docker compose restart mon1 mgr
docker compose exec mon1 chown -R ceph:ceph /etc/ceph
docker compose exec mon1 chown -R ceph:ceph /var/lib/ceph
docker compose exec mon1 ceph osd pool create cephfs_data 128
docker compose exec mon1 ceph auth get client.bootstrap-rgw -o /var/lib/ceph/bootstrap-rgw/ceph.keyring
docker compose exec mon1 ceph auth get client.bootstrap-osd -o /var/lib/ceph/bootstrap-osd/ceph.keyring
docker compose exec mon1 ceph auth get client.bootstrap-mds -o /var/lib/ceph/bootstrap-mds/ceph.keyring


docker compose up -d osd1 osd2 osd3 osd4

docker compose up -d rgw1
docker compose up -d mds1
sleep 3
docker compose ps -a
# docker compose logs -f osd1