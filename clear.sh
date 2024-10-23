#!/bin/bash
docker compose down
docker network rm ceph-cluster-net
sudo rm -rf ceph
sudo rm -rf osds