#!/bin/bash
# --force-recreate is used to recreate container when crontab file has changed
source ~/openrc.sh
INSTANCE=$(/home/yohan/env_py3/bin/openstack server show -c id --format value $(hostname))
sudo mkdir -p /mnt/volumes/elasticsearch_data
if ! mountpoint -q /mnt/volumes/elasticsearch_data
then
     VOLUME_ID=$(/home/yohan/env_py3/bin/openstack volume show elasticsearch_data -c id --format value)
     test -e /dev/disk/by-id/*${VOLUME_ID:0:20} || nova volume-attach $INSTANCE $VOLUME_ID auto
     sleep 3
     sudo mount /dev/disk/by-id/*${VOLUME_ID:0:20} /mnt/volumes/elasticsearch_data
fi

unset VERSION_ELASTICSEARCH
export VERSION_ELASTICSEARCH=$(git ls-remote https://git.scimetis.net/yohan/docker-elasticsearch.git| head -1 | cut -f 1|cut -c -10)

mkdir -p ~/build
git clone https://git.scimetis.net/yohan/docker-elasticsearch.git ~/build/docker-elasticsearch
sudo docker build -t elasticsearch:$VERSION_ELASTICSEARCH ~/build/docker-elasticsearch

sudo -E bash -c 'docker-compose up -d --force-recreate'

rm -rf ~/build
