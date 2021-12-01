# Dockerfile for OpenLogReplicator
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
#
# OpenLogReplicator Dockerfile
# --------------------------
# This is the Dockerfile for OpenLogReplicator
#
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
#
# (1) instantclient-basic-linux.x64-19.12.0.0.zip
# (2) instantclient-sdk-linux.x64-19.12.0.0.zip
#     Download from https://www.oracle.com/database/technologies/instant-client.html
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Run:
#       $ docker build -t bersler/openlogreplicator:centos-8 -f Dockerfile --build-arg IMAGE=centos --build-arg VERSION=8 --build-arg GIDOLR=1001 --build-arg UIDOLR=1001 --build-arg GIDORA=1000 --build-arg WITHKAFKA=1 --build-arg WITHPROTOBUF=1 --build-arg WITHROCKETMQ=1 --build-arg WITHORACLE=1 --build-arg BUILDDEV=1 .
#       $ docker build -t bersler/openlogreplicator:debian-11.0 -f Dockerfile --build-arg IMAGE=debian --build-arg VERSION=11.0 --build-arg GIDOLR=1001 --build-arg UIDOLR=1001 --build-arg GIDORA=1000 --build-arg WITHKAFKA=1 --build-arg WITHPROTOBUF=1 --build-arg WITHROCKETMQ=1 --build-arg WITHORACLE=1 --build-arg BUILDDEV=1 .
#       $ docker build -t bersler/openlogreplicator:ubuntu-20.04 -f Dockerfile --build-arg IMAGE=ubuntu --build-arg VERSION=20.04 --build-arg GIDOLR=1001 --build-arg UIDOLR=1001 --build-arg GIDORA=1000 --build-arg WITHKAFKA=1 --build-arg WITHPROTOBUF=1 --build-arg WITHROCKETMQ=1 --build-arg WITHORACLE=1 --build-arg BUILDDEV=1 .
#

ARG IMAGE=centos
ARG VERSION=8
FROM ${IMAGE}:${VERSION} as builder

ARG GIDOLR=1001
ARG UIDOLR=1001
ARG GIDORA=1000
ARG BUILDDEV
ARG WITHKAFKA
ARG WITHORACLE
ARG WITHPROTOBUF
ARG WITHROCKETMQ
ARG TZ

MAINTAINER Adam Leszczynski <aleszczynski@bersler.com>

ENV LC_ALL=C
ENV LANG en_US.UTF-8
ENV ORACLE_MAJOR 19
ENV ORACLE_MINOR 12
ENV PROTOBUF_VERSION 3.19.1
ENV RAPIDJSON_VERSION 1.1.0
ENV LIBRDKAFKA_VERSION 1.8.0
ENV ROCKETMQ_VERSION 2.2.0
ENV OPENLOGREPLICATOR_VERSION 0.9.35-beta
ENV LD_LIBRARY_PATH=/opt/instantclient_${ORACLE_MAJOR}_${ORACLE_MINOR}:/opt/librdkafka/lib
ENV CFLAGS="${BUILDDEV:+-fsanitize\=address}"
ENV CXXFLAGS="${BUILDDEV:+-g -O0 -fsanitize\=address}"
ENV CXXFLAGS="${CXXFLAGS:--O3}"
ENV LDFLAGS="${BUILDDEV:+-fsanitize\=address}"
ENV BUILDARGS="--with-rapidjson=/opt/rapidjson"
ENV BUILDARGS="${BUILDARGS}${WITHKAFKA:+ --with-rdkafka=/opt/librdkafka}"
ENV BUILDARGS="${BUILDARGS}${WITHORACLE:+ --with-instantclient=/opt/instantclient_${ORACLE_MAJOR}_${ORACLE_MINOR}}"
ENV BUILDARGS="${BUILDARGS}${WITHPROTOBUF:+ --with-protobuf=/opt/protobuf}"
ENV BUILDARGS="${BUILDARGS}${WITHROCKETMQ:+ --with-rocketmq=/opt/rocketmq-client-cpp}"
ENV COMPILEKAFKA="${WITHKAFKA:+1}"
ENV COMPILEORACLE="${WITHORACLE:+1}"
ENV COMPILEPROTOBUF="${WITHPROTOBUF:+1}"
ENV COMPILEROCKETMQ="${WITHROCKETMQ:+1}"
ENV TZ=${TZ:-Europe/Warsaw}
ENV DEBIAN_FRONTEND=noninteractive
      
COPY LICENSE instantclient-basic-linux.x64-${ORACLE_MAJOR}.${ORACLE_MINOR}.0.0.0dbru.zip /tmp/
COPY LICENSE instantclient-sdk-linux.x64-${ORACLE_MAJOR}.${ORACLE_MINOR}.0.0.0dbru.zip /tmp/

RUN set -eux ; \
    if [ -r /etc/centos-release ]; then \
        yum -y install autoconf automake diffutils file gcc gcc-c++ libaio libaio-devel libasan libnsl libtool make patch tar unzip wget zlib-devel ; \
        if [ "${COMPILEROCKETMQ}" != "" ]; then \
            yum -y install bzip2-devel cmake perl ; \
        fi ; \
    fi ; \
    if [ -r /etc/debian_version ]; then \
        apt-get update ; \
        apt-get -y install file gcc g++ libaio1 libasan5 libasan6 libtool libz-dev make patch unzip wget ; \
        if [ "${COMPILEROCKETMQ}" != "" ]; then \
            apt-get -y install cmake libbz2-dev perl ; \
        fi ; \
    fi ; \
    cd /opt ; \
    wget https://github.com/Tencent/rapidjson/archive/refs/tags/v${RAPIDJSON_VERSION}.tar.gz ; \
    tar xzvf v${RAPIDJSON_VERSION}.tar.gz ; \
    rm v${RAPIDJSON_VERSION}.tar.gz ; \
    ln -s rapidjson-${RAPIDJSON_VERSION} rapidjson ; \
    if [ "${COMPILEORACLE}" != "" ]; then \
        cd /opt ; \
        unzip /tmp/instantclient-basic-linux.x64-${ORACLE_MAJOR}.${ORACLE_MINOR}.0.0.0dbru.zip ; \
        rm /tmp/instantclient-basic-linux.x64-${ORACLE_MAJOR}.${ORACLE_MINOR}.0.0.0dbru.zip ; \
        unzip /tmp/instantclient-sdk-linux.x64-${ORACLE_MAJOR}.${ORACLE_MINOR}.0.0.0dbru.zip ; \
        rm /tmp/instantclient-sdk-linux.x64-${ORACLE_MAJOR}.${ORACLE_MINOR}.0.0.0dbru.zip ; \
        cd /opt/instantclient_${ORACLE_MAJOR}_${ORACLE_MINOR} ; \
        ln -s libclntshcore.so.${ORACLE_MAJOR}.1 libclntshcore.so ; \
    fi ; \
    if [ "${COMPILEKAFKA}" != "" ]; then \
        cd /opt ; \
        wget https://github.com/edenhill/librdkafka/archive/refs/tags/v${LIBRDKAFKA_VERSION}.tar.gz ; \
        tar xzvf v${LIBRDKAFKA_VERSION}.tar.gz ; \
        rm v${LIBRDKAFKA_VERSION}.tar.gz ; \
        cd /opt/librdkafka-${LIBRDKAFKA_VERSION} ; \
        ./configure --prefix=/opt/librdkafka ; \
        make ; \
        make install ; \
    fi ; \
    if [ "${COMPILEROCKETMQ}" != "" ]; then \
        cd /opt ; \
        wget https://github.com/apache/rocketmq-client-cpp/archive/refs/tags/${ROCKETMQ_VERSION}.tar.gz ; \
        tar xzvf ${ROCKETMQ_VERSION}.tar.gz ; \
        rm ${ROCKETMQ_VERSION}.tar.gz ; \
        ln -s rocketmq-client-cpp-${ROCKETMQ_VERSION} rocketmq-client-cpp ; \
        cd rocketmq-client-cpp ; \
        wget https://github.com/bersler/rocketmq-client-cpp/commit/45d54e076aaf2804efcdc158ebe66cc09a07ed80.patch ; \
        patch -p 1 < 45d54e076aaf2804efcdc158ebe66cc09a07ed80.patch ; \
        ./build.sh ; \
    fi ; \
    if [ "${COMPILEPROTOBUF}" != "" ]; then \
        cd /opt ; \
        wget https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VERSION}/protobuf-cpp-${PROTOBUF_VERSION}.tar.gz ; \
        tar xzvf protobuf-cpp-${PROTOBUF_VERSION}.tar.gz ; \
        rm protobuf-cpp-${PROTOBUF_VERSION}.tar.gz ; \
        cd /opt/protobuf-${PROTOBUF_VERSION} ; \
        ./configure --prefix=/opt/protobuf ; \
        make ; \
        make install ; \
    fi ; \
    cd /opt ; \
    mkdir /opt/OpenLogReplicator ; \
    mkdir /opt/OpenLogReplicator/scripts-src ; \
    wget https://github.com/bersler/OpenLogReplicator/archive/refs/tags/${OPENLOGREPLICATOR_VERSION}.tar.gz ; \
    tar xzvf ${OPENLOGREPLICATOR_VERSION}.tar.gz ; \
    rm ${OPENLOGREPLICATOR_VERSION}.tar.gz ; \
    cd /opt/OpenLogReplicator-${OPENLOGREPLICATOR_VERSION} ; \
    autoreconf -f -i ; \
    ./configure CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}" ${BUILDARGS} ; \
    if [ "${COMPILEPROTOBUF}" != "" ]; then \
        cd proto ; \
        /opt/protobuf/bin/protoc OraProtoBuf.proto --cpp_out=. ; \
        mv OraProtoBuf.pb.cc ../src/OraProtoBuf.pb.cpp ; \
        mv OraProtoBuf.pb.h ../src/OraProtoBuf.pb.h ; \
        cd .. ; \
    fi ; \
    make ; \
    mv src/OpenLogReplicator /opt/OpenLogReplicator ; \
    mv scripts/* /opt/OpenLogReplicator/scripts-src ; \
    mv AUTHORS /opt/OpenLogReplicator ; \
    mv CHANGELOG /opt/OpenLogReplicator ; \
    mv LICENSE /opt/OpenLogReplicator ; \
    mv README.md /opt/OpenLogReplicator ; \
    rm -rf /opt/OpenLogReplicator-${OPENLOGREPLICATOR_VERSION} /opt/rapidjson /opt/rapidjson-${RAPIDJSON_VERSION} ; \
    if [ "${COMPILEKAFKA}" != "" ]; then \
        rm -rf /opt/librdkafka-${LIBRDKAFKA_VERSION} ; \
    fi ; \
    if [ "${COMPILEPROTOBUF}" != "" ]; then \
        rm -rf /opt/protobuf-${PROTOBUF_VERSION} ; \
    fi ; \
    if [ -r /etc/centos-release ]; then \
        yum -y remove autoconf automake file gcc gcc-c++ libaio-devel libtool make patch unzip wget zlib-devel ; \
        if [ "${COMPILEROCKETMQ}" != "" ]; then \
            yum -y remove bzip2-devel cmake perl ; \
        fi ; \
        yum -y autoremove ; \
        yum clean all ; \
    rm -rf /var/cache/yum ; \
    fi ; \
    if [ -r /etc/debian_version ]; then \
        apt-get -y remove file gcc g++ libtool libz-dev make unzip wget ; \
        if [ "${COMPILEROCKETMQ}" != "" ]; then \
            apt-get -y remove cmake libbz2-dev perl ; \
        fi ; \
        apt-get -y autoremove ; \
        apt-get clean ; \
        rm -rf /var/lib/apt/lists/* ; \
    fi ; \
    mkdir /home/user1 ; \
    groupadd -g ${GIDOLR} user1 ; \
    if [ "${GIDOLR}" != "${GIDORA}" ]; then groupadd -g ${GIDORA} oracle; useradd -u ${UIDOLR} user1 -g user1 -G oracle -d /home/user1; else useradd -u ${UIDOLR} user1 -g user1 -d /home/user1; fi ; \
    chown -R user1:user1 /home/user1 ; \
    su - user1 -c "export LD_LIBRARY_PATH=/opt/instantclient_${ORACLE_MAJOR}_${ORACLE_MINOR}:/opt/librdkafka/lib:/opt/rocketmq-client-cpp/bin; /opt/OpenLogReplicator/OpenLogReplicator --version"

USER user1
WORKDIR /opt/OpenLogReplicator
ENTRYPOINT ./OpenLogReplicator
