#!/bin/sh
set -e

exec litecoind -printtoconsole "$@"
