# OpenLogReplicator-docker
This repository contains basic Dockerfile for [OpenLogReplicator](https://github.com/bersler/OpenLogReplicator)

You can compile with Debian or Ubuntu image: `bersler/openlogreplicator`

Refer to `build.sh` for reference how to run docker build command.

The script will automatically create a Docker image with the main binary placed in `/opt/OpenLogReplicator`. 
During image creation, you should see version banner in the output:

    + ./src/OpenLogReplicator
    2023-05-31 23:59:56 [INFO] OpenLogReplicator v.1.2.0 (C) 2018-2023 by Adam Leszczynski (aleszczynski@bersler.com), see LICENSE file for licensing information

This would mean that the binary is correctly built.
You can provide custom `GID/UID` - which is used to run OpenLogReplicator.
The configured group/user is used by binaries in the Docker image to run the OpenLogReplicator process.
Choose the group/user that would have appropriate privileges to access the database files (write checkpoint files and read redo log files).

Example:

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
