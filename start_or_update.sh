#!/bin/bash
# --force-recreate is used to recreate container when crontab file has changed
unset VERSION_ELASTICSEARCH
VERSION_ELASTICSEARCH=$(git ls-remote https://git.scimetis.net/yohan/docker-elasticsearch.git| head -1 | cut -f 1|cut -c -10) \
 sudo -E bash -c 'docker-compose up -d --force-recreate'
