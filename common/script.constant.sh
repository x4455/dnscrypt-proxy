#!/system/bin/sh
# >常量
IPTABLES=/system/bin/iptables
IP6TABLES=/system/bin/ip6tables

CORE_BINARY=dnsproxy_core
CORE_PATH=$MODPATH/$CORE_BINARY

CONFIG="/data/media/dnscrypt-proxy/dnscrypt-proxy.toml"
