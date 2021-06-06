# Copyright (C) 2018-2021 Adam Leszczynski.
#
# This file is part of Open Log Replicator docker template.
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
#
# OpenLogReplicator Dockerfile
# --------------------------
# This is the Dockerfile for OpenLogReplicator
#
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
#
# (1) instantclient-basic-linux.x64-19.11.0.0.zip
# (2) instantclient-sdk-linux.x64-19.11.0.0.zip
#     Download from https://www.oracle.com/database/technologies/instant-client.html
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Run:
#      $ docker build -t bersler/openlogreplicator .
#
# This command is already scripted on build.sh so you can alternatively run
#		$ bash build.sh

FROM centos:7 as builder

MAINTAINER Adam Leszczynski <aleszczynski@bersler.com>

COPY instantclient-basic-linux.x64-19.11.0.0.0dbru.zip /tmp/instantclient-basic-linux.x64-19.11.0.0.0dbru.zip
COPY instantclient-sdk-linux.x64-19.11.0.0.0dbru.zip /tmp/instantclient-sdk-linux.x64-19.11.0.0.0dbru.zip

ENV LANG en_US.UTF-8
ENV LD_LIBRARY_PATH=/opt/instantclient_19_11:/opt/librdkafka/lib

RUN set -eux ; \
	yum -y update ; \
	yum install -y \
		make \
		gcc \
		gcc-c++ \
		git \
		unzip \
		libasan \
		libaio-devel \
		libnsl \
		autoconf \
		automake \
		libtool \
		wget \
		tar ; \
	rm -rf /var/cache/yum ; \
	cd /opt ; \
	unzip /tmp/instantclient-basic-linux.x64-19.11.0.0.0dbru.zip ; \
	unzip /tmp/instantclient-sdk-linux.x64-19.11.0.0.0dbru.zip ; \
	cd /opt/instantclient_19_11 ; \
	ln -s libclntshcore.so.19.1 libclntshcore.so ; \
	cd /opt ; \
	git clone https://github.com/Tencent/rapidjson ; \
	mkdir /opt/librdkafka-src ; \
	cd /opt/librdkafka-src ; \
	git clone https://github.com/edenhill/librdkafka ; \
	cd librdkafka ; \
	./configure --prefix=/opt/librdkafka ; \
	make ; \
	make install ; \
	mkdir -p /opt/grpc ; \
	export PATH=$PATH:/opt/grpc/bin ; \
	wget -q -O cmake-linux.sh https://github.com/Kitware/CMake/releases/download/v3.17.0/cmake-3.17.0-Linux-x86_64.sh ; \
	sh cmake-linux.sh -- --skip-license --prefix=/opt/grpc ; \
	rm -f cmake-linux.sh ; \
	mkdir /opt/grpc-src ; \
	cd /opt/grpc-src ; \
	git clone --recurse-submodules -b v1.31.0 https://github.com/grpc/grpc ; \
	cd grpc ; \
	mkdir -p cmake/build ; \
	pushd cmake/build ; \
	cmake -DgRPC_INSTALL=ON -DgRPC_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=/opt/grpc ../.. ; \
	make -j ; \
	make install ; \
	popd ; \
	cd /opt ; \
	git clone https://github.com/bersler/OpenLogReplicator ; \
	cd /opt/OpenLogReplicator ; \
	autoreconf -f -i ; \
	./configure CXXFLAGS='-O3' --with-rapidjson=/opt/rapidjson --with-rdkafka=/opt/librdkafka --with-instantclient=/opt/instantclient_19_11 ; \
	make ; \
	./src/OpenLogReplicator
