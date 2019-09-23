# Listen port (Keep consistent with listen_addresses)
V4LPT=5354
V6LPT=5354

# iptables block port 53 INPUT #
ipt_block_INPUT=false
whitelist="
9.9.9.9
"

# If you device are not supported "IPv6 nat", set this option to "true"
# and remove IPv6 from "listen_addresses" in the config file.
# iptables block IPv6 port 53 #
ipt_block_IPv6_OUTPUT=false

# Clear the log after booting
ClearList="
dnscrypt-proxy.log
query.log
nx.log
blocked.log
ip-blocked.log
whitelisted.log
"

# Constant (If you don't know what you are doing, don't modify it.)
IPTABLES=/system/bin/iptables
IP6TABLES=/system/bin/ip6tables

CONFIG="/data/media/dnscrypt-proxy/dnscrypt-proxy.toml"

CORE_BINARY=dnsproxy-core
CORE_PATH=$MODPATH/$CORE_BINARY
CORE_BOOT="$CORE_PATH -config $CONFIG"  ## With "&"
