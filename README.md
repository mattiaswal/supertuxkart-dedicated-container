# SuperTuxKart Docker Container

Docker container to run SuperTuxKart on headless embedded systems. This container is designed for systems that have graphics drivers but are not running X11 - it brings its own X server.

## Purpose

This container is intended for headless systems with:
- Graphics hardware and drivers (DRM/KMS support)
- No existing X11 installation
- Direct hardware access capabilities

The container provides its own X11 server and graphics stack, making it perfect for embedded systems, kiosks, or headless servers that need to display graphics directly to connected displays.

## Building

Build the container and create OCI archive:
```bash
make
```

Other build options:
- `make build` - Build Docker image only
- `make clean` - Remove image and archive

## Running

### Basic Usage

```bash
docker run --privileged \
  -m type=bind,source=/run/udev/,target=/run/udev/ \
  -v :/var \
  mattiaswal/supertuxkart:latest
```

### Infix Configuration

For use with [Infix](https://github.com/kernelkit/infix) on
e.g. Raspberry Pi 4

```json

{
  "infix-containers:containers": {
    "container": [
      {
        "name": "stk",
        "image": "oci-archive:/var/lib/oci/supertuxkart-oci.tar",
        "privileged": true,
        "network": {
          "host": true
        },
        "mount": [
          {
            "name": "dbus",
            "type": "bind",
            "source": "/run/dbus/",
            "target": "/run/dbus/"
          },
          {
            "name": "udev",
            "type": "bind",
            "source": "/run/udev/",
            "target": "/run/udev/"
          }
        ],
        "volume": [
          {
            "name": "games",
            "target": "/usr/share/games"
          },
          {
            "name": "var",
            "target": "/var"
          }
        ]
      }
    ]
  }
}
```

Connect a USB mouse and keyboard to start playing SuperTuxKart.

## Requirements

- Docker with buildx support
- ARM64 platform support for target deployment
- Graphics hardware with DRM/KMS drivers
- No existing X11 server (container provides its own)
- USB input devices (mouse/keyboard)

## Configuration

The container includes:
- Self-contained X11 server
- Mesa graphics drivers and EGL support
- Custom display configuration with rotation support
- Power management disabled for continuous operation
- Optimized for embedded systems without desktop environments
