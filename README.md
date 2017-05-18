# Litecoind for Docker

[![Docker Stars](https://img.shields.io/docker/stars/salessandri/docker-litecoind.svg)](https://hub.docker.com/r/salessandri/docker-litecoind/)
[![Docker Pulls](https://img.shields.io/docker/pulls/salessandri/docker-litecoind.svg)](https://hub.docker.com/r/salessandri/docker-litecoind/)
[![ImageLayers](https://images.microbadger.com/badges/image/salessandri/docker-litecoind.svg)](https://microbadger.com/images/salessandri/docker-litecoind)

Docker image that runs the Litecoin litecoind node in a container for easy deployment.

## Quick Start

In order to setup a Litecoin node with the default options (no wallet and no RPC server) perform the following steps:

1. Create a volume for the litecoin data.

```
docker volume create --name=litecoind-data
```

All the data the litecoind service needs to work will be stored in the volume.
The volume can then be reused to restore the state of the service in case the container needs to be recreated (in case of a host restart or when upgrading the version).

2. Create and run a container with the `docker-litecoind` image.

```
docker run -d \
    --name litecoind-node \
    -v litecoind-data:/litecoin \
    -p 9333:9333 \
    --restart unless-stopped \
    salessandri/docker-litecoind
```

This will create a container named `litecoind-node` which gets the host's port 9333 forwarded to it.
Also this container will restart in the event it crashes or the host is restarted.

3. Inspect the output of the container by using docker logs

```
docker logs -f litecoind-node
```

## Configuration Customization

There are 4 different ways to customize the configuration of the `litecoind` daemon.

### Environment Variables to the Config Generator

If there is no `litecoin.conf` file in the work directory (`/litecoin`), the container creates a basic configuration file based on environmental variables.
By default the only option it overrides is the wallet option, making it disabled.

The following are the environmental variables that can be used to change that default behavior:

- `ENABLE_WALLET`: If set, the configuration will not disable the wallet and the `litecoind` daemon will create one.
- `MAX_CONNECTIONS`: When set (should be an integer), it overrides the max connections value.
- `RPC_SERVER`: If set, it enables the JSON RPC server on port 9332. If no user is given, the user will be set to `litecoinrpc` and if no password is given a random one will be generated.
The configuration file is the first thing printed by the container and the password can be read from the logs.
- `RPC_USER`: Only used if `RPC_SERVER` is set. This states which user needs to used for the JSON RPC server.
- `RPC_PASSWORD`: Only used if `RPC_SERVER` is set. This states the password to used for the JSON RPC server.

This values can be set by adding a `-e VARIABLE=VALUE` for each of the values that want to be overriden in the `docker run` command (before the image name).

Example:
```
docker run -d \
    --name litecoind-node \
    -v litecoind-data:/litecoin \
    -p 9333:9333 \
    --restart unless-stopped \
    -e ENABLE_WALLET=1 \
    -e MAX_CONNECTIONS=25 \
    salessandri/docker-litecoind
```

### Mounting a `litecoin.conf` file on `/litecoin/litecoin.conf`

If one wants to write their own `litecoin.conf` and have it persisted on the host but keep all the
`litecoind` data inside a docker volume one can mount a file volume on `/litecoin/litecoin.conf` after the litecoin data volume.

Example:
```
docker run -d \
    --name litecoind-node \
    -v litecoind-data:/litecoin \
    -v /etc/litecoin.conf:/litecoin/litecoin.conf \
    -p 9333:9333 \
    --restart unless-stopped \
    salessandri/docker-litecoind
```

### Have a `litecoin.conf` in the litecoin data directory

Instead of using a docker volume for the litecoin data, one can mount directory on `/litecoin` for the container to use as the litecoin data directory.
If this directory has a `litecoin.conf` file, this file will be used.

Just create a directory in the host machine (e.g. `/var/litecoind-data`) and place your `litecoin.conf` file in it.
Then, when creating the container in the `docker run`, instead of naming a volume to mount use the directory.

```
docker run -d \
    --name litecoind-node
    -v /var/litecoind-data:/litecoin \
    -p 9333:9333 \
    --restart unless-stopped \
    salessandri/docker-litecoind
```

### Extra arguments to docker run

All the extra arguments given to `docker run` (the ones after the image name) are forwarded to the `litecoind` process.
This can be used to change the behavior of the `litecoind` service.

Example:
```
docker run -d \
    --name litecoind-node
    -v litecoind-data:/litecoin \
    -p 9333:9333 \
    --restart unless-stopped \
    salessandri/docker-litecoind \
    -timeout=10000 -proxy=10.0.0.5:3128
```

_Note: This doesn't prevent the default `litecoin.conf` file to be created in the volume._
