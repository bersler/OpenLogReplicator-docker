# OpenLogReplicator-docker
Dockerfile for OpenLogReplicator

To create a dockerfile you must download Oracle Instant Client from Oracle:
(1) instantclient-basic-linux.x64-11.2.0.4.0.zip
(2) instantclient-sdk-linux.x64-11.2.0.4.0.zip

You can download the files from https://www.oracle.com/database/technologies/instant-client.html
Place the files in the main folder and run:

bash build.sh

The script will automatically create a docker image with OpenLogReplicator. The image is based on CentOS 7.
