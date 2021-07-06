#!/bin/sh
docker build -t bersler/openlogreplicator:centos-7 -f Dockerfile-centos-7 .
docker build -t bersler/openlogreplicator-pb:centos-7 -f Dockerfile-centos-7-pb .
docker build -t bersler/openlogreplicator:ubuntu-20.04 -f Dockerfile-ubuntu-20.04 .
docker build -t bersler/openlogreplicator-pb:ubuntu-20.04 -f Dockerfile-ubuntu-20.04-pb .
