#!/bin/bash
#Absolute path to this script
SCRIPT=$(readlink -f $0)
#Absolute path this script is in
SCRIPTPATH=$(dirname $SCRIPT)

cd $SCRIPTPATH
unset VERSION_ELASTICSEARCH
export VERSION_ELASTICSEARCH=$(git ls-remote https://git.scimetis.net/yohan/docker-elasticsearch.git| head -1 | cut -f 1|cut -c -10)

mkdir -p ~/build
git clone https://git.scimetis.net/yohan/docker-elasticsearch.git ~/build/docker-elasticsearch
sudo docker build -t elasticsearch:$VERSION_ELASTICSEARCH ~/build/docker-elasticsearch

sudo -E bash -c 'docker-compose up --no-start'

rm -rf ~/build
