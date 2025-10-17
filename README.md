# SuperTuxKart Dedicated Server Container

Docker container to run a SuperTuxKart dedicated server. This is a server-only build without graphics, designed to host multiplayer games.

## Purpose

This container runs a headless SuperTuxKart server for multiplayer gaming. It's built with `SERVER_ONLY=ON` and includes no graphics dependencies.

## Building

Build the container for multiple platforms (linux/aarch64, linux/amd64):
```bash
make build
```

This will build and push the image to Docker Hub. To clean up:
```bash
make clean
```

## Running

### Basic Docker Usage

```bash
docker run -d \
  -p 2759:2759/udp \
  -v $(pwd)/server_config.xml:/stk-data/server_config.xml \
  mattiaswal/supertuxkart-dedicated:latest
```

You need to provide a `server_config.xml` file for server configuration.

### Infix Configuration

For use with [Infix](https://kernelkit.org/infix/latest/container/) on embedded systems like Raspberry Pi 4:

```bash
admin@infix:/> configure
admin@infix:/config/> edit container stk-server
admin@infix:/config/container/stk-server/> set image docker://mattiaswal/supertuxkart-dedicated:latest
admin@infix:/config/container/stk-server/> set network host
admin@infix:/config/container/stk-server/> set publish 2759:2759/udp
admin@infix:/config/container/stk-server/> edit mount stk-data
admin@infix:/config/container/stk-server/mount/stk-data/> set source /cfg/stk-data
admin@infix:/config/container/stk-server/mount/stk-data/> set target /stk-data
admin@infix:/config/container/stk-server/mount/stk-data/> end
admin@infix:/config/container/stk-server/> leave
admin@infix:/> copy running-config startup-config
```

Place your `server_config.xml` in `/cfg/stk-data/` on the Infix host.

## Requirements

- Docker with buildx support (for building)
- Network connectivity for players to connect
- Valid `server_config.xml` configuration file

## What's Included

The container includes:
- SuperTuxKart dedicated server (server-only build)
- Built from latest STK source code
- Minimal Alpine Linux base image
- Non-root user for security
- Support for ARM64 and AMD64 platforms
