#!/bin/sh
# Script to build Docker images
# Copyright (C) 2018-2025 Adam Leszczynski (aleszczynski@bersler.com)
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
GIDOLR=${GIDOLR:=`id -r -g ${USER}`}
UIDOLR=${UIDOLR:=`id -r -u ${USER}`}
GIDORA=${GIDORA:=54322}
BASE_IMAGE=${BASE_IMAGE:=debian}
BASE_VERSION=${BASE_VERSION:=12.0}
OLR_IMAGE=${OLR_IMAGE:=bersler/openlogreplicator:${BASE_IMAGE}-${BASE_VERSION}}
BUILD_ARGS=""

if [ "$GIDOLR" -eq "0" ] || [ "$UIDOLR" -eq "0" ]; then
    echo "Failed, you are not allowed to run OpenLogReplicator as root"
    exit 1
fi

if [ ! -z "${OPENLOGREPLICATOR_VERSION}" ]; then
    BUILD_ARGS="--build-arg OPENLOGREPLICATOR_VERSION=${OPENLOGREPLICATOR_VERSION}"
fi

docker build \
-t ${OLR_IMAGE} \
-f Dockerfile \
${BUILD_ARGS} \
--build-arg IMAGE=${BASE_IMAGE} \
--build-arg VERSION=${BASE_VERSION} \
--build-arg GIDOLR=${GIDOLR} \
--build-arg UIDOLR=${UIDOLR} \
--build-arg GIDORA=${GIDORA} \
--build-arg WITHORACLE=1 \
--build-arg WITHKAFKA=1 \
--build-arg WITHPROMETHEUS=1 \
--build-arg WITHPROTOBUF=1 \
--build-arg BUILD_TYPE=Release .
