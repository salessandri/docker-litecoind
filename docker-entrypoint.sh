#!/bin/sh
set -e

exec litecoind -datadir=/litecoin -printtoconsole "$@"
