#!/system/bin/sh
# DNSCrypt-Proxy 2
# Convenient control script

[[ "$#" -eq 0 ]] && { echo "! Null input !"; exit 1; }
[[ $(id -u) -ne 0 ]] && { echo "! Need root !"; exit 1; }

[ -f /proc/net/ip6_tables_names ] && { ipt_setIPv6='true'; }||{ ipt_setIPv6='false'; }

MODPATH=/data/adb/modules/dnscrypt-proxy
source $MODPATH/constant.sh

function gconf()
{
 grep $1 $CONFIG;
}

IPv4_LISTEN_PORT="`gconf 'listen_addresses' | awk -F "'" '{print $2}' | awk -F ":" '{print $2}'`"
IPv6_LISTEN_PORT="`gconf 'listen_addresses' | awk -F "'" '{print $4}' | awk -F "]:" '{print $2}'`"
RESOLVER="`gconf 'fallback_resolver' | awk -F "[':]" '{print $2}'`"

### Get whitelist
Wlist=('1.1.1.1' '1.0.0.1')
i="${#Wlist[*]}";
  for TARGET in $IPv4_whitelist
  do
    Wlist[i]=$TARGET; ((i++))
  done
### Load iptables rules

function ip4trules_wlist_load()
{
 IPS=$1
  for IP in ${Wlist[*]}
  do
    echo "W: $IP $IPS"
    for IPP in 'udp' 'tcp'
    do
      $IPTABLES -t nat $IPS OUTPUT -p $IPP -d $IP --dport 53 -j ACCEPT
    done
  done
}

function ip4trules_load()
{
 IPS=$1
  for IPP in 'udp' 'tcp'
  do
    echo "IPTABLES $IPP $IPv4_LISTEN_PORT $IPS"
    $IPTABLES -t nat $IPS OUTPUT -p $IPP ! -d $RESOLVER --dport 53 -j DNAT --to-destination 127.0.0.1:$IPv4_LISTEN_PORT
  done
}

function ip6trules_load()
{
 IPS=$1
  if [ "$ipt_blockIPv6" == "true" ]; then
    echo "Block IPv6 $IPS";
    blockIPv6 $IPS
  else
    for IPP in 'udp' 'tcp'
    do
      echo "IP6TABLES $IPP $IPv6_LISTEN_PORT $IPS"
      $IP6TABLES -t nat $IPS OUTPUT -p $IPP --dport 53 -j DNAT --to-destination [::1]:$IPv6_LISTEN_PORT
    done
  fi
}

function blockIPv6()
{
 IPS=$1
  $IP6TABLES -t filter $IPS OUTPUT -p udp --dport 53 -j DROP
  $IP6TABLES -t filter $IPS OUTPUT -p tcp --dport 53 -j REJECT --reject-with tcp-reset
}

# Check rules
function ip4trules_wlist_check()
{
 r=0
  for IPP in 'udp' 'tcp'
  do
    [ -n "`$IPTABLES -n -t nat -L OUTPUT | grep "ACCEPT.*$IPP.*dpt:53"`" ] && ((r++))
  done
 [ $r -gt 0 ] && return 0
}

function iptrules_check()
{
 IPT=$IPTABLES; IPA='127.0.0.1'; r=0
  for IPP in 'udp' 'tcp'
  do
    [ -n "`$IPT -n -t nat -L OUTPUT | grep "DNAT.*$IPP.*dpt:53.*to:$IPA:$IPv4_LISTEN_PORT"`" ] && ((r++))
  done
 [ $r -gt 0 ] && return 0
}

function core_check()
{
 [ -n "`pgrep $CORE_BINARY`" ] && return 0
}

# Main
function iptrules_on()
{
  ip4trules_load '-I'
  if [ "$ipt_setIPv6" == "true" ]; then
    ip6trules_load '-I'
  else
    echo "Skip IPv6"
  fi
  ip4trules_wlist_load '-I'
}

function iptrules_off()
{
  while ip4trules_wlist_check; do
    ip4trules_wlist_load '-D'
  done
  while iptrules_check; do
    ip4trules_load '-D'
    if [ "$ipt_setIPv6" == "true" ]; then
      ip6trules_load '-D'
    else
      echo "Skip IPv6"
    fi
  done
}

## Other

function core_start()
{
  core_check && killall $CORE_BINARY
  sleep 1
  echo "- Core online $(date +'%d|%r')"
  $CORE_PATH -config $CONFIG &
  sleep 12
}

### Processing options
 case $* in
  # Boot
  -start)
  iptrules_off
  core_start
  if core_check; then
   iptrules_on
  else
   echo '(!)Fails:Core is not working'; exit 1
  fi
  ;;
  # Boot Core only
  -start-core)
  core_start
  if [ ! core_check ]; then
   echo '(!)Fails:Core is not working'; exit 1
  fi
  ;;
  # Stop
  -stop)
  echo '- Stop proxy'
  iptrules_off
  killall $CORE_BINARY
  echo '- Done'
  ;;
  # Check status
  -status)  i=0
  core_check && { echo '< Core Online >'; }||{ echo '! Core Offline !'; i=`expr $i + 2`; }
  iptrules_check && { echo '< iprules Enabled >'; }||{ echo '! iprules Disabled !'; i=`expr $i + 1`; }
  [ $i == 3 ] && exit 22 #All
  [ $i == 2 ] && exit 02 #iprules
  [ $i == 1 ] && exit 20 #Core
  ;;
  # Help
  -usage)
cat <<EOD
dnsproxy [string]
 -start
  Start dnscrypt-proxy
 -stop
  Stop dnscrypt-proxy
 -status
  Proxy Status
 -start-core
  Boot core only
 -reset-rules
  Reset iptables
EOD
  ;;
#### Advanced Features
  # Clean iptables rules
  -reset-rules)
  iptables -t nat -F OUTPUT
  ip6tables -t nat -F OUTPUT
  sleep 1
  blockIPv6 '-D'
  killall $CORE_BINARY
  echo '- Done'
  ;;
  # Pass command
  *)
  $CORE_PATH -config $CONFIG $*
  ;;
 esac
exit 0
