# OpenLogReplicator-docker
Dockerfile for OpenLogReplicator

You can compile with Debian or Ubuntu image: bersler/openlogreplicator

Please refer to build.sh for reference how to run docker build command.

The script will automatically create a docker image with /opt/OpenLogReplicator. As a result you should see version banner:

        + ./src/OpenLogReplicator
        2022-12-10 23:59:56 [INFO] OpenLogReplicator v.1.0.0 (C) 2018-2023 by Adam Leszczynski (aleszczynski@bersler.com), see LICENSE file for licensing information

It means that the binary is correctly build. You can provide custom GID/UID - which is used to run OpenLogReplicator. The group/user would be used by docker image to run the OpenLogReplicator process. Please choose the group/user that would have appropriate privileges to access files (write checkpoint files and read redo log files).

5. Running example:

        mkdir script
        mkdir checkpoint
        vi scripts/OpenLogReplicator.json
        # create some content for config and run
        docker run --name OpenLogReplicator -v /opt/fast-recovery-area:/opt/fast-recovery-area \
        -v ./scripts:/opt/OpenLogReplicator/scripts \
        -v ./checkpoint:/opt/OpenLogReplicator/checkpoint \
        bersler/openlogreplicator:debian-11.0

## Sponsoring the Project

If you (or your company) are benefiting from the project and would like to support the contributor, kindly support the project.

<a href="https://www.buymeacoffee.com/bersler" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-blue.png" alt="Buy Me A Coffee" style="height: 40px !important;width: 160px !important;" ></a>
