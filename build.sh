#!/bin/sh
# Script to build Docker images
# Copyright (C) 2018-2021 Adam Leszczynski (aleszczynski@bersler.com)
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

docker build -t bersler/openlogreplicator:centos-8 -f Dockerfile-centos-8 .
docker build -t bersler/openlogreplicator-pb:centos-8 -f Dockerfile-centos-8-pb .
docker build -t bersler/openlogreplicator:ubuntu-20.04 -f Dockerfile-ubuntu-20.04 .
docker build -t bersler/openlogreplicator-pb:ubuntu-20.04 -f Dockerfile-ubuntu-20.04-pb .
