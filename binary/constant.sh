# If you device are not supported "IPv6 nat", set this option to "false"
# and remove IPv6 from "listen_addresses" in the config file.
#####
#ipt_setIPv6=false

# iptables block IPv6 port 53 #
ipt_blockIPv6=false

# IPv4 port 53 whitelist #
# All use 53 port DNS in forwarding-rules,
# need to be added to the whitelist.
#This is an example
IPv4_whitelist_EXAMPLE="
1.1.1.1
1.0.0.1
"

IPv4_whitelist="
"

# Constant (If you don't know what you are doing, don't modify it.)
IPTABLES=/system/bin/iptables
IP6TABLES=/system/bin/ip6tables

CONFIG="/data/media/dnscrypt-proxy/dnscrypt-proxy.toml"

CORE_BINARY=dnsproxy-core
CORE_PATH=$MODPATH/$CORE_BINARY
