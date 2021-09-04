# OpenLogReplicator-docker
Dockerfile for OpenLogReplicator

To create a dockerfile you must download Oracle Instant Client from Oracle:
1. instantclient-basic-linux.x64-19.12.0.0.0dbru.zip
2. instantclient-sdk-linux.x64-19.12.0.0.0dbru.zip

You can download the files from https://www.oracle.com/database/technologies/instant-client.html

1. Compile with CentOS 8 image: bersler/openlogreplicator:centos-8
Place the files in the folder and run:

        docker build -t bersler/openlogreplicator:centos-8 -f Dockerfile-centos-8 --build-arg GID=1000 --build-arg UID=1000 .

2. Compile with CentOS 8 image with protobuf: bersler/openlogreplicator-pb:centos-8
Place the files in the folder and run:

        docker build -t bersler/openlogreplicator-pb:centos-8 -f Dockerfile-centos-8-pb --build-arg GID=1000 --build-arg UID=1000 .

3. Compile with Debian 11.0 image: bersler/openlogreplicator:debian-11.0
Place the files in the folder and run:

        docker build -t bersler/openlogreplicator:debian-11.0 -f Dockerfile-debian-11.0 --build-arg GID=1000 --build-arg UID=1000 .

4. Compile with Debian 11.0 image with protobuf: bersler/openlogreplicator-pb:debian-11.0
Place the files in the folder and run:

        docker build -t bersler/openlogreplicator-pb:debian-11.0 -f Dockerfile-debian-11.0-pb --build-arg GID=1000 --build-arg UID=1000 .

5. Compile with Ubuntu 20.04 image: bersler/openlogreplicator:ubuntu-20.04
Place the files in the folder and run:

        docker build -t bersler/openlogreplicator:ubuntu-20.04 -f Dockerfile-ubuntu-20.04 --build-arg GID=1000 --build-arg UID=1000 .

6. Compile with Ubuntu 20.04 image with protobuf: bersler/openlogreplicator-pb:ubuntu-20.04
Place the files in the folder and run:

        docker build -t bersler/openlogreplicator-pb:ubuntu-20.04 -f Dockerfile-ubuntu-20.04-pb --build-arg GID=1000 --build-arg UID=1000 .


The script will automatically create a docker image with /opt/OpenLogReplicator. As a result you should see version banner:

        + ./src/OpenLogReplicator
        2021-09-04 12:34:56 [INFO] OpenLogReplicator v.0.9.25-beta (C) 2018-2021 by Adam Leszczynski (aleszczynski@bersler.com), see LICENSE file for licensing information

It means that the binary is correctly build. You can provide custom GID/UID - which is used to run OpenLogReplicator. The group/user would be used by docker image to run the OpenLogReplicator process. Please choose the group/user that would have appropriate privileges to access files (write checkpoint files and read redo log files).

5. Running example:

        mkdir script
        mkdir checkpoint
        vi scripts/OpenLogReplicator.json
        # create some content for config and run
        docker run --name OpenLogReplicator -v /opt/fast-recovery-area:/opt/fast-recovery-area \
        -v ./scripts:/opt/OpenLogReplicator/scripts \
        -v ./checkpoint:/opt/OpenLogReplicator/checkpoint \
        bersler/openlogreplicator:ubuntu-20.04
