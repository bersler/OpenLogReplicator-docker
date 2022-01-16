#!/bin/sh
# Script to build Docker images
# Copyright (C) 2018-2022 Adam Leszczynski (aleszczynski@bersler.com)
#
# This file is part of OpenLogReplicator
# 
# Open Log Replicator is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published
# by the Free Software Foundation; either version 3, or (at your option)
# any later version.
# 
# Open Log Replicator is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
# Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Open Log Replicator; see the file LICENSE.txt  If not see
# <http://www.gnu.org/licenses/>.

USER=`whoami`
GIDOLR=`id -r -g ${USER}`
UIDOLR=`id -r -u ${USER}`
GIDORA=1000

#dev build with Oracle libraries
docker build -t bersler/openlogreplicator:centos-8-dev -f Dockerfile --build-arg IMAGE=centos --build-arg VERSION=8 --build-arg GIDOLR=${GIDOLR} --build-arg UIDOLR=${UIDOLR} --build-arg GIDORA=${GIDORA} --build-arg WITHORACLE=1 --build-arg BUILDDEV=1 .
docker build -t bersler/openlogreplicator:debian-11.0-dev -f Dockerfile --build-arg IMAGE=debian --build-arg VERSION=11.0 --build-arg GIDOLR=${GIDOLR} --build-arg UIDOLR=${UIDOLR} --build-arg GIDORA=${GIDORA} --build-arg WITHORACLE=1 --build-arg BUILDDEV=1 .
docker build -t bersler/openlogreplicator:ubuntu-20.04-dev -f Dockerfile --build-arg IMAGE=ubuntu --build-arg VERSION=20.04 --build-arg GIDOLR=${GIDOLR} --build-arg UIDOLR=${UIDOLR} --build-arg GIDORA=${GIDORA} --build-arg WITHORACLE=1 --build-arg BUILDDEV=1 . 

#dev build with Oracle libraries & Kafka output
docker build -t bersler/openlogreplicator:centos-8-kafka -f Dockerfile --build-arg IMAGE=centos --build-arg VERSION=8 --build-arg GIDOLR=${GIDOLR} --build-arg UIDOLR=${UIDOLR} --build-arg GIDORA=${GIDORA} --build-arg WITHORACLE=1 --build-arg WITHKAFKA=1 --build-arg BUILDDEV=1 .
docker build -t bersler/openlogreplicator:debian-11.0-kafka -f Dockerfile --build-arg IMAGE=debian --build-arg VERSION=11.0 --build-arg GIDOLR=${GIDOLR} --build-arg UIDOLR=${UIDOLR} --build-arg GIDORA=${GIDORA} --build-arg WITHORACLE=1 --build-arg WITHKAFKA=1 --build-arg BUILDDEV=1 .
docker build -t bersler/openlogreplicator:ubuntu-20.04-kafka -f Dockerfile --build-arg IMAGE=ubuntu --build-arg VERSION=20.04 --build-arg GIDOLR=${GIDOLR} --build-arg UIDOLR=${UIDOLR} --build-arg GIDORA=${GIDORA} --build-arg WITHORACLE=1 --build-arg WITHKAFKA=1 --build-arg BUILDDEV=1 . 

#dev build with Oracle libraries & protobuf
docker build -t bersler/openlogreplicator:centos-8-protobuf -f Dockerfile --build-arg IMAGE=centos --build-arg VERSION=8 --build-arg GIDOLR=${GIDOLR} --build-arg UIDOLR=${UIDOLR} --build-arg GIDORA=${GIDORA} --build-arg WITHORACLE=1 --build-arg WITHPROTOBUF=1 --build-arg BUILDDEV=1 .
docker build -t bersler/openlogreplicator:debian-11.0-protobuf -f Dockerfile --build-arg IMAGE=debian --build-arg VERSION=11.0 --build-arg GIDOLR=${GIDOLR} --build-arg UIDOLR=${UIDOLR} --build-arg GIDORA=${GIDORA} --build-arg WITHORACLE=1 --build-arg WITHPROTOBUF=1 --build-arg BUILDDEV=1 .
docker build -t bersler/openlogreplicator:ubuntu-20.04-protobuf -f Dockerfile --build-arg IMAGE=ubuntu --build-arg VERSION=20.04 --build-arg GIDOLR=${GIDOLR} --build-arg UIDOLR=${UIDOLR} --build-arg GIDORA=${GIDORA} --build-arg WITHORACLE=1 --build-arg WITHPROTOBUF=1 --build-arg BUILDDEV=1 . 

#dev build with Oracle libraries & RocketMQ output
docker build -t bersler/openlogreplicator:centos-8-rocketmq -f Dockerfile --build-arg IMAGE=centos --build-arg VERSION=8 --build-arg GIDOLR=${GIDOLR} --build-arg UIDOLR=${UIDOLR} --build-arg GIDORA=${GIDORA} --build-arg WITHORACLE=1 --build-arg WITHROCKETMQ=1 --build-arg BUILDDEV=1 .
docker build -t bersler/openlogreplicator:debian-11.0-rocketmq -f Dockerfile --build-arg IMAGE=debian --build-arg VERSION=11.0 --build-arg GIDOLR=${GIDOLR} --build-arg UIDOLR=${UIDOLR} --build-arg GIDORA=${GIDORA} --build-arg WITHORACLE=1 --build-arg WITHROCKETMQ=1 --build-arg BUILDDEV=1 .
docker build -t bersler/openlogreplicator:ubuntu-20.04-rocketmq -f Dockerfile --build-arg IMAGE=ubuntu --build-arg VERSION=20.04 --build-arg GIDOLR=${GIDOLR} --build-arg UIDOLR=${UIDOLR} --build-arg GIDORA=${GIDORA} --build-arg WITHORACLE=1 --build-arg WITHROCKETMQ=1 --build-arg BUILDDEV=1 . 

#prod build with all targets
docker build -t bersler/openlogreplicator:centos-8 -f Dockerfile --build-arg IMAGE=centos --build-arg VERSION=8 --build-arg GIDOLR=${GIDOLR} --build-arg UIDOLR=${UIDOLR} --build-arg GIDORA=${GIDORA} --build-arg WITHORACLE=1 --build-arg WITHKAFKA=1 --build-arg WITHPROTOBUF=1 --build-arg WITHROCKETMQ=1 .
docker build -t bersler/openlogreplicator:debian-11.0 -f Dockerfile --build-arg IMAGE=debian --build-arg VERSION=11.0 --build-arg GIDOLR=${GIDOLR} --build-arg UIDOLR=${UIDOLR} --build-arg GIDORA=${GIDORA} --build-arg WITHORACLE=1 --build-arg WITHKAFKA=1 --build-arg WITHPROTOBUF=1 --build-arg WITHROCKETMQ=1 .
docker build -t bersler/openlogreplicator:ubuntu-20.04 -f Dockerfile --build-arg IMAGE=ubuntu --build-arg VERSION=20.04 --build-arg GIDOLR=${GIDOLR} --build-arg UIDOLR=${UIDOLR} --build-arg GIDORA=${GIDORA} --build-arg WITHORACLE=1 --build-arg WITHKAFKA=1 --build-arg WITHPROTOBUF=1 --build-arg WITHROCKETMQ=1 . 
