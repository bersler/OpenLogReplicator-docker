# OpenLogReplicator-docker
This repository contains basic Dockerfile for [OpenLogReplicator](https://github.com/bersler/OpenLogReplicator)

You can compile with Debian or Ubuntu image: `bersler/openlogreplicator`

Refer to `build.sh` for reference how to run docker build command.

The script will automatically create a Docker image with the main binary placed in `/opt/OpenLogReplicator`. 
During image creation, you should see version banner in the output:

    + ./src/OpenLogReplicator
    2024-01-27 23:55:02 INFO  00000 OpenLogReplicator v1.5.0 (C) 2018-2024 by Adam Leszczynski (aleszczynski@bersler.com), see LICENSE file for licensing information
    2024-01-27 23:55:02 INFO  00000 arch: x86_64, system: Linux, release: 6.1.0-16-amd64, build: Release, compiled: 2024-01-27 22:49, modules: Kafka OCI Prometheus Protobuf

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
    bersler/openlogreplicator:debian-12.0

## Support OpenLogReplicator-docker

If you feel that I should receive some feedback from the world to continue with my hard work - feel free to make a **donation** or become a **sponsor**.

I am very grateful for any amount you donate.

[![Sponsor via GitHub](https://img.shields.io/badge/Sponsor-GitHub-brightgreen)](https://github.com/sponsors/bersler)
[![Librepay](https://img.shields.io/badge/Donate-Librepay-orange)](https://liberapay.com/bersler)
[![Buy Me a Coffee](https://img.shields.io/badge/Donate-Coffee-yellow)](https://www.buymeacoffee.com/bersler)
