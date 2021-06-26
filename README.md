# OpenLogReplicator-docker
Dockerfile for OpenLogReplicator

To create a dockerfile you must download Oracle Instant Client from Oracle:
1. instantclient-basic-linux.x64-19.11.0.0.0dbru.zip
2. instantclient-sdk-linux.x64-19.11.0.0.0dbru.zip

You can download the files from https://www.oracle.com/database/technologies/instant-client.html

1. Compile with CentOS 7 image:
Place the files in the folder and run:

        cd CentOS
        bash build.sh

2. Compile with CentOS 7 image with protobuf:
Place the files in the folder and run:

        cd CentOS-protobuf
        bash build.sh

3. Compile with Ubuntu 20.04 image:
Place the files in the folder and run:

        cd Ubuntu
        bash build.sh

4. Compile with Ubuntu 20.04 image with protobuf:
Place the files in the folder and run:

        cd Ubuntu-protobuf
        bash build.sh

The script will automatically create a docker image with OpenLogReplicator. As a result you should see something like:

        + ./src/OpenLogReplicator
        2021-06-26 23:05:06 [INFO] OpenLogReplicator v.0.9.2-beta (C) 2018-2021 by Adam Leszczynski (aleszczynski@bersler.com), see LICENSE file for licensing information
        2021-06-26 23:05:06 [ERROR] can't open file OpenLogReplicator.json

It means that the binary is correctly build. Just the program requires config file to run, but all dependencies and libraries are correct.