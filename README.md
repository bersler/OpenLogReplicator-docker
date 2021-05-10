# OpenLogReplicator-docker
Dockerfile for OpenLogReplicator

To create a dockerfile you must download Oracle Instant Client from Oracle:
1. instantclient-basic-linux.x64-19.10.0.0.0dbru.zip
2. instantclient-sdk-linux.x64-19.10.0.0.0dbru.zip

You can download the files from https://www.oracle.com/database/technologies/instant-client.html

1. Compile with CentOS 7 image:
Place the files in the folder and run:

        cd CentOS
        bash build.sh

2. Compile with Ubuntu 20.04 image:
Place the files in the folder and run:

        cd Ubuntu
        bash build.sh

The script will automatically create a docker image with OpenLogReplicator.
