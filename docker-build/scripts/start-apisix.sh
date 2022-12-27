#!/bin/bash

mkdir -p $APISIX_HOME/logs
$APISIX_HOME/bin/apisix start -c $APISIX_HOME/conf/config.yaml >>$APISIX_HOME/logs/apisix.stdout.log 2>>$APISIX_HOME/logs/apisix.stderr.log &
