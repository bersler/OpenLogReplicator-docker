#!/bin/sh
docker build -t bersler/openlogreplicator:centos-8 -f Dockerfile-centos-8 .
docker build -t bersler/openlogreplicator-pb:centos-8 -f Dockerfile-centos-8-pb .
docker build -t bersler/openlogreplicator:ubuntu-20.04 -f Dockerfile-ubuntu-20.04 .
docker build -t bersler/openlogreplicator-pb:ubuntu-20.04 -f Dockerfile-ubuntu-20.04-pb .
