# Introduction

This docker-compose for deploy ceph version 14.2.9 & Container version v4.0.12-stable-4.0-nautilus-centos-7-x86_64

## Setup

[more info](https://docs.ceph.com/en/latest/)

## Quick Start

1. configuration `.env`
``` bash
cp env-example .env && vim .env
```

2. up all
``` bash
./start.sh
```

3. set dashboard
``` bash
./dashboard.sh
```

