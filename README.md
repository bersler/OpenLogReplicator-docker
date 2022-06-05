# OpenLogReplicator-docker
Dockerfile for OpenLogReplicator

You can compile with Debian or Ubuntu image: bersler/openlogreplicator

Please refer to build.sh for reference how to run docker build command.

The script will automatically create a docker image with /opt/OpenLogReplicator. As a result you should see version banner:

        + ./src/OpenLogReplicator
        2021-09-12 12:34:56 [INFO] OpenLogReplicator v.0.9.30-beta (C) 2018-2021 by Adam Leszczynski (aleszczynski@bersler.com), see LICENSE file for licensing information

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
