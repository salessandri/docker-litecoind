#!/bin/sh

# This script sets up the base litecoind.conf file to be used by the litecoind process. It only has
# an effect if there is no litecoind.conf file in litecoind's work directory.
#
# The options it sets can be tweaked by setting environmental variables when creating the docker
# container.
#

set -ex

if [[ -e "/litecoin/litecoin.conf" ]]; then
    exit 0
fi

MAX_CONNECTIONS=${MAX_CONNECTIONS:-125}
RPC_USER=${RPC_USER:-litecoinrpc}
RPC_PASSWORD=${RPC_PASSWORD:-$(dd if=/dev/urandom bs=20 count=1 2>/dev/null | base64)}

if [[ -z ${ENABLE_WALLET:+x} ]]; then
    echo "disablewallet=1" >> "/litecoin/litecoin.conf"
fi

echo "maxconnection=${MAX_CONNECTION}" >> "/litecoin/litecoin.conf"

if [[ ! -z ${RPC_SERVER:+x} ]]; then
    echo "server=1" >> "/litecoin/litecoin.conf"
    echo "rpcuser=${RPC_USER}" >> "/litecoin/litecoin.conf"
    echo "rpcpassword=${RPC_PASSWORD}" >> "/litecoin/litecoin.conf"
fi;
