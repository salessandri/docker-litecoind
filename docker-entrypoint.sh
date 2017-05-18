#!/bin/sh
set -e

litecoind_setup.sh

echo "################################################"
echo "# Configuration used: /litecoin/litecoin.conf  #"
echo "################################################"

exec litecoind -datadir=/litecoin -conf=/litecoin/litecoin.conf -printtoconsole "$@"
