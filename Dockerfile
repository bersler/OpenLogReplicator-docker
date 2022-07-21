# Dockerfile for OpenLogReplicator
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
#
# OpenLogReplicator Dockerfile
# --------------------------
# This is the Dockerfile for OpenLogReplicator
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Run:
#       $ docker build -t bersler/openlogreplicator:debian-11.0 -f Dockerfile --build-arg IMAGE=debian --build-arg VERSION=11.0 --build-arg GIDOLR=${GIDOLR} --build-arg UIDOLR=${UIDOLR} --build-arg GIDORA=${GIDORA} --build-arg WITHORACLE=1 --build-arg WITHKAFKA=1 --build-arg WITHPROTOBUF=1 --build-arg BUILD_TYPE=Release .
#       $ docker build -t bersler/openlogreplicator:ubuntu-20.04 -f Dockerfile --build-arg IMAGE=ubuntu --build-arg VERSION=20.04 --build-arg GIDOLR=${GIDOLR} --build-arg UIDOLR=${UIDOLR} --build-arg GIDORA=${GIDORA} --build-arg WITHORACLE=1 --build-arg WITHKAFKA=1 --build-arg WITHPROTOBUF=1 --build-arg BUILD_TYPE=Release .
#

ARG IMAGE=debian
ARG VERSION=11.0
FROM ${IMAGE}:${VERSION} as builder

ARG OPENLOGREPLICATOR_VERSION=0.9.49
ARG ARCH=x86_64
ARG GIDOLR=1001
ARG UIDOLR=1001
ARG GIDORA=54322
ARG BUILD_TYPE
ARG WITHKAFKA
ARG WITHORACLE
ARG WITHPROTOBUF
ARG TZ

MAINTAINER Adam Leszczynski <aleszczynski@bersler.com>

ENV LC_ALL=C
ENV LANG en_US.UTF-8
ENV ORACLE_MAJOR 19
ENV ORACLE_MINOR 15
ENV PROTOBUF_VERSION_DIR 21.3
ENV PROTOBUF_VERSION 3.21.2
ENV RAPIDJSON_VERSION 1.1.0
ENV LIBRDKAFKA_VERSION 1.9.1
ENV OPENLOGREPLICATOR_VERSION ${OPENLOGREPLICATOR_VERSION}
ENV LD_LIBRARY_PATH=/opt/instantclient_${ORACLE_MAJOR}_${ORACLE_MINOR}:/opt/librdkafka/lib
ENV BUILDARGS="-DCMAKE_BUILD_TYPE=${BUILD_TYPE} -DWITH_RAPIDJSON=/opt/rapidjson -S ../ -B ./"
ENV BUILDARGS="${BUILDARGS}${WITHKAFKA:+ -DWITH_RDKAFKA=/opt/librdkafka}"
ENV BUILDARGS="${BUILDARGS}${WITHORACLE:+ -DWITH_OCI=/opt/instantclient_${ORACLE_MAJOR}_${ORACLE_MINOR}}"
ENV BUILDARGS="${BUILDARGS}${WITHPROTOBUF:+ -DWITH_PROTOBUF=/opt/protobuf}"
ENV COMPILEKAFKA="${WITHKAFKA:+1}"
ENV COMPILEORACLE="${WITHORACLE:+1}"
ENV COMPILEPROTOBUF="${WITHPROTOBUF:+1}"
ENV TZ=${TZ:-Europe/Warsaw}
ENV DEBIAN_FRONTEND=noninteractive

RUN set -eu ; \
    if [ -r /etc/centos-release ]; then \
        yum -y install autoconf automake diffutils file gcc gcc-c++ libaio libaio-devel libasan libnsl libtool make patch tar unzip wget zlib-devel ; \
    fi ; \
    if [ -r /etc/debian_version ]; then \
        apt-get update ; \
        apt-get -y install file gcc g++ libaio1 libasan5 libasan6 libtool libz-dev make patch unzip wget cmake ; \
    fi ; \
    cd /opt ; \
    wget https://github.com/Tencent/rapidjson/archive/refs/tags/v${RAPIDJSON_VERSION}.tar.gz ; \
    tar xzvf v${RAPIDJSON_VERSION}.tar.gz ; \
    rm v${RAPIDJSON_VERSION}.tar.gz ; \
    ln -s rapidjson-${RAPIDJSON_VERSION} rapidjson ; \
    if [ "${COMPILEORACLE}" != "" ]; then \
        cd /opt ; \
        wget https://download.oracle.com/otn_software/linux/instantclient/${ORACLE_MAJOR}${ORACLE_MINOR}000/instantclient-basic-linux.x64-${ORACLE_MAJOR}.${ORACLE_MINOR}.0.0.0dbru.zip ; \
        unzip instantclient-basic-linux.x64-${ORACLE_MAJOR}.${ORACLE_MINOR}.0.0.0dbru.zip ; \
        rm instantclient-basic-linux.x64-${ORACLE_MAJOR}.${ORACLE_MINOR}.0.0.0dbru.zip ; \
        wget https://download.oracle.com/otn_software/linux/instantclient/${ORACLE_MAJOR}${ORACLE_MINOR}000/instantclient-sdk-linux.x64-${ORACLE_MAJOR}.${ORACLE_MINOR}.0.0.0dbru.zip ; \
        unzip instantclient-sdk-linux.x64-${ORACLE_MAJOR}.${ORACLE_MINOR}.0.0.0dbru.zip ; \
        rm instantclient-sdk-linux.x64-${ORACLE_MAJOR}.${ORACLE_MINOR}.0.0.0dbru.zip ; \
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
    if [ "${COMPILEPROTOBUF}" != "" ]; then \
        cd /opt ; \
        wget https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VERSION_DIR}/protobuf-cpp-${PROTOBUF_VERSION}.tar.gz ; \
        tar xzvf protobuf-cpp-${PROTOBUF_VERSION}.tar.gz ; \
        rm protobuf-cpp-${PROTOBUF_VERSION}.tar.gz ; \
        cd /opt/protobuf-${PROTOBUF_VERSION} ; \
        ./configure --prefix=/opt/protobuf ; \
        make ; \
        make install ; \
    fi ; \
    cd /opt ; \
    wget https://github.com/bersler/OpenLogReplicator/archive/refs/tags/${OPENLOGREPLICATOR_VERSION}.tar.gz ; \
    tar xzvf ${OPENLOGREPLICATOR_VERSION}.tar.gz ; \
    rm ${OPENLOGREPLICATOR_VERSION}.tar.gz ; \
    cd /opt/OpenLogReplicator-${OPENLOGREPLICATOR_VERSION} ; \
    if [ "${COMPILEPROTOBUF}" != "" ]; then \
        cd proto ; \
        /opt/protobuf/bin/protoc OraProtoBuf.proto --cpp_out=. ; \
        mv OraProtoBuf.pb.cc ../src/common/OraProtoBuf.pb.cpp ; \
        mv OraProtoBuf.pb.h ../src/common/OraProtoBuf.pb.h ; \
        cd .. ; \
    fi ; \
    mkdir cmake-build-${BUILD_TYPE}-${ARCH} ; \
    cd cmake-build-${BUILD_TYPE}-${ARCH} ; \
    cmake ${BUILDARGS} ; \
    cmake --build ./ --target OpenLogReplicator -j ; \
    mkdir /opt/OpenLogReplicator ; \
    mkdir /opt/OpenLogReplicator/log ; \
    mkdir /opt/OpenLogReplicator/scripts ; \
    mv ./OpenLogReplicator /opt/OpenLogReplicator ; \
    mkdir /home/user1 ; \
    groupadd -g ${GIDOLR} user1 ; \
    if [ "${GIDOLR}" != "${GIDORA}" ]; then \
        groupadd -g ${GIDORA} oracle ; \
        useradd -u ${UIDOLR} user1 -g user1 -G oracle -d /home/user1 ; \
    else \
        useradd -u ${UIDOLR} user1 -g user1 -d /home/user1 ; \
    fi ; \
    chown -R user1:user1 /home/user1 ; \
    chown -R user1:user1 /opt/OpenLogReplicator ; \
    if [ "${BUILD_TYPE}" != "Debug" ]; then \
        rm -rf /opt/OpenLogReplicator-${OPENLOGREPLICATOR_VERSION} /opt/rapidjson /opt/rapidjson-${RAPIDJSON_VERSION} ; \
        if [ "${COMPILEKAFKA}" != "" ]; then \
            rm -rf /opt/librdkafka-${LIBRDKAFKA_VERSION} ; \
        fi ; \
        if [ "${COMPILEPROTOBUF}" != "" ]; then \
            rm -rf /opt/protobuf-${PROTOBUF_VERSION} ; \
        fi ; \
        if [ -r /etc/centos-release ]; then \
            yum -y remove autoconf automake file gcc gcc-c++ libaio-devel libtool make patch unzip wget zlib-devel ; \
            yum -y autoremove ; \
            yum clean all ; \
        rm -rf /var/cache/yum ; \
        fi ; \
        if [ -r /etc/debian_version ]; then \
            apt-get -y remove file gcc g++ libtool libz-dev make unzip wget ; \
            apt-get -y autoremove ; \
            apt-get clean ; \
            rm -rf /var/lib/apt/lists/* ; \
        fi ; \
    fi

USER user1:oracle
RUN set -eu ; \
    export LD_LIBRARY_PATH=/opt/instantclient_${ORACLE_MAJOR}_${ORACLE_MINOR}:/opt/librdkafka/lib; \
    /opt/OpenLogReplicator/OpenLogReplicator --version

WORKDIR /opt/OpenLogReplicator
ENTRYPOINT ./OpenLogReplicator >>/opt/OpenLogReplicator/log/OpenLogReplicator.txt 2>>/opt/OpenLogReplicator/log/OpenLogReplicator.err
