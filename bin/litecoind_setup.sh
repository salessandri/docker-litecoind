#!/bin/sh

# This script sets up the base litecoind.conf file to be used by the litecoind process. It only has
# an effect if there is no litecoind.conf file in litecoind's work directory.
#
# The options it sets can be tweaked by setting environmental variables when creating the docker
# container.
#

set -e

if [ -e "/litecoin/litecoin.conf" ]; then
    exit 0
fi

if [ -z ${ENABLE_WALLET:+x} ]; then
    echo "disablewallet=1" >> "/litecoin/litecoin.conf"
fi

if [ ! -z ${MAX_CONNECTIONS:+x} ]; then
    echo "maxconnection=${MAX_CONNECTIONS}" >> "/litecoin/litecoin.conf"
fi

if [ ! -z ${RPC_SERVER:+x} ]; then
    RPC_USER=${RPC_USER:-litecoinrpc}
    RPC_PASSWORD=${RPC_PASSWORD:-$(dd if=/dev/urandom bs=20 count=1 2>/dev/null | base64)}

    echo "server=1" >> "/litecoin/litecoin.conf"
    echo "rpcuser=${RPC_USER}" >> "/litecoin/litecoin.conf"
    echo "rpcpassword=${RPC_PASSWORD}" >> "/litecoin/litecoin.conf"
fi;
