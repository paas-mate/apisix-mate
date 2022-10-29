#!/bin/bash

DIR="$( cd "$( dirname "$0"  )" && pwd  )"

mkdir -p $APISIX_HOME/logs
bash -x $DIR/start-apisix.sh
