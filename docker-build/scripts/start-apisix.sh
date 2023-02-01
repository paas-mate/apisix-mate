#!/bin/bash

mkdir -p $APISIX_HOME/logs

# fetch config from env
config_path=$APISIX_HOME/conf/my_config.yaml

echo "apisix:" > $config_path
echo "  ssl:">> $config_path
echo "    ssl_trusted_certificate: $SSL_TRUSTED_CERTIFICATE" >> $config_path
echo "deployment:" >> $config_path
echo "  etcd:" >> $config_path
echo "    host:" >> $config_path
etcd_hosts_array=(${ETCD_HOSTS//,/ })
for host in ${etcd_hosts_array[@]}
do
  echo "      - $host" >> $config_path
done
echo "    prefix: \"/apisix\"" >> $config_path
echo "    tls:" >> $config_path
CONF_ETCD_CLIENT_CERT=${ETCD_CLIENT_CERT:-/etc/kubernetes/pki/apiserver-etcd-client.crt}
CONF_ETCD_CLIENT_KEY=${ETCD_CLIENT_KEY:-/etc/kubernetes/pki/apiserver-etcd-client.key}
echo "      cert: $CONF_ETCD_CLIENT_CERT" >> $config_path
echo "      key: $CONF_ETCD_CLIENT_KEY" >> $config_path
echo "      verify: false" >> $config_path
echo "  role: traditional" >> $config_path
echo "  role_traditional:" >> $config_path
echo "    config_provider: etcd" >> $config_path
echo "  admin:" >> $config_path
echo "    admin_key:" >> $config_path
echo "      - name: admin" >> $config_path
CONF_ADMIN_KEY=${ADMIN_KEY:-edd1c9f034335f136f87ad84b625c8f1}
echo "        key: $CONF_ADMIN_KEY" >> $config_path
echo "        role: admin" >> $config_path
if [[ ${DISCOVERY_NACOS_ENABLE} == "true" ]]; then
  echo "discovery:" >> $config_path
  echo "  nacos:" >> $config_path
  echo "    host:" >> $config_path
  echo "      - ${DISCOVERY_NACOS_HOST}" >> $config_path
  echo "    prefix: \"/nacos/v1\"" >> $config_path
  echo "    fetch_interval: ${DISCOVERY_NACOS_FETCH_INTERVAL}" >> $config_path
  echo "    weight: ${DISCOVERY_NACOS_WEIGHT}" >> $config_path
  echo "    timeout:" >> $config_path
  echo "      connect: ${DISCOVERY_NACOS_TIMEOUT_CONNECT}" >> $config_path
  echo "      send: ${DISCOVERY_NACOS_TIMEOUT_SEND}" >> $config_path
  echo "      read: ${DISCOVERY_NACOS_TIMEOUT_READ}" >> $config_path
fi
cd $APISIX_HOME
./bin/apisix start -c $APISIX_HOME/conf/my_config.yaml >>$APISIX_HOME/logs/apisix.stdout.log 2>>$APISIX_HOME/logs/apisix.stderr.log &
