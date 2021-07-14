# OpenLogReplicator-docker
Dockerfile for OpenLogReplicator

To create a dockerfile you must download Oracle Instant Client from Oracle:
1. instantclient-basic-linux.x64-19.11.0.0.0dbru.zip
2. instantclient-sdk-linux.x64-19.11.0.0.0dbru.zip

You can download the files from https://www.oracle.com/database/technologies/instant-client.html

1. Compile with CentOS 8 image: bersler/openlogreplicator:centos-8
Place the files in the folder and run:

        docker build -t bersler/openlogreplicator:centos-8 -f Dockerfile-centos-8 .

2. Compile with CentOS 8 image with protobuf: bersler/openlogreplicator-pb:centos-8
Place the files in the folder and run:

        docker build -t bersler/openlogreplicator-pb:centos-8 -f Dockerfile-centos-8-pb .

3. Compile with Ubuntu 20.04 image: bersler/openlogreplicator:ubuntu-20.04
Place the files in the folder and run:

        docker build -t bersler/openlogreplicator:ubuntu-20.04 -f Dockerfile-ubuntu-20.04 .

4. Compile with Ubuntu 20.04 image with protobuf: bersler/openlogreplicator-pb:ubuntu-20.04
Place the files in the folder and run:

        docker build -t bersler/openlogreplicator-pb:ubuntu-20.04 -f Dockerfile-ubuntu-20.04-pb .

The script will automatically create a docker image with /opt/OpenLogReplicator. As a result you should see version banner:

        + ./src/OpenLogReplicator
        2021-07-15 12:34:56 [INFO] OpenLogReplicator v.0.9.15-beta (C) 2018-2021 by Adam Leszczynski (aleszczynski@bersler.com), see LICENSE file for licensing information

It means that the binary is correctly build.

5. Running example:

        mkdir script
        mkdir checkpoint
        vi scripts/OpenLogReplicator.json
        # create some content for config and run
        docker run --name OpenLogReplicator -v /opt/fast-recovery-area:/opt/fast-recovery-area \
        -v ./scripts:/opt/OpenLogReplicator/scripts \
        -v ./checkpoint:/opt/OpenLogReplicator/checkpoint \
        bersler/openlogreplicator:ubuntu-20.04
