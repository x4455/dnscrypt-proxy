#!/system/bin/sh
# Script by x4455 @ github
[[ "$#" -eq 0 ]] && { echo "Null input"; exit 1; }
[[ $(id -u) -ne 0 ]] && { echo "Need root permission"; exit 1; }

MODPATH=/data/adb/modules/dnscrypt-proxy
source $MODPATH/constant.sh

gconf(){ grep $1 $CONFIG; }
[ -f /proc/net/ip6_tables_names ] && IPv6_S=true || IPv6_S=false
LISTEN_PORT="`gconf 'listen_addresses' | awk -F "[:']" '{print $3}'`"
FALLBACK_RESOLVER="`gconf 'fallback_resolver' | awk -F "[':]" '{print $2}'`"

Wlist=('1.1.1.1' '1.0.0.1')
if [ ! -n "`gconf '#.*forwarding_rules'`" ]; then
 cache=$(gconf 'forwarding_rules' | awk -F "\'" '{print $2}')
 [ -n "`echo $cache | grep '/'`" ] && list_FILE=$cache || list_FILE=${CONFIG%/*}/$cache
 cache=$(grep -E 'whitelist.=' $list_FILE | awk -F "[()]" '{print $2}')
 i="${#Wlist[*]}"; OLD_IFS="$IFS"; IFS=","; array=($cache); IFS="$OLD_IFS"; cache=false
  for cache in ${array[*]}; do
   Wlist[i]=$cache; ((i++))
  done
fi
###

iptrules_wlist_load(){
 IPS=$1
 for IP in ${Wlist[*]}; do
  echo "W: $IP $IPS"
  for IPP in 'udp' 'tcp'; do
   $IPTABLES -t nat $IPS OUTPUT -p $IPP -d $IP --dport 53 -j ACCEPT
  done
 done
}

iptrules_load(){
 IPT=$1; IPS=$2; IPA=$3
 for IPP in 'udp' 'tcp'; do
  echo "$IPT $IPP $LISTEN_PORT $IPS"
  if [ $IPT == $IPTABLES ]; then
   $IPT -t nat $IPS OUTPUT -p $IPP ! -d ${FALLBACK_RESOLVER} --dport 53 -j DNAT --to-destination $IPA:$LISTEN_PORT
  else
   $IPT -t raw $IPS OUTPUT -p $IPP --dport 53 -j DNAT --to-destination $IPA:$LISTEN_PORT
  fi
 done
}

#
iptrules_wlist_check(){
 r=0
 for IPP in 'udp' 'tcp'; do
  [ -n "`$IPTABLES -n -t nat -L OUTPUT | grep "ACCEPT.*$IPP.*dpt:53"`" ] && ((r++))
 done
[ $r -gt 0 ] && return 0
}

core_check(){
[ -n "`pgrep $CORE_BINARY`" ] && return 0
}

iptrules_check(){
 IPT=$IPTABLES; IPA='127.0.0.1'; r=0
 for IPP in 'udp' 'tcp'; do
  [ -n "`$IPT -n -t nat -L OUTPUT | grep "DNAT.*$IPP.*dpt:53.*to:$IPA:$LISTEN_PORT"`" ] && ((r++))
 done
[ $r -gt 0 ] && return 0
}

#
iptrules_on(){
 iptrules_wlist_load '-A'
 iptrules_load $IPTABLES '-A' '127.0.0.1'
 $IPv6_S && { iptrules_load $IP6TABLES '-A' '[::1]'; }
}

iptrules_off(){
 while iptrules_wlist_check; do
  iptrules_wlist_load '-D'
 done
 while iptrules_check; do
  iptrules_load $IPTABLES '-D' '127.0.0.1'
  $IPv6_S && { iptrules_load $IP6TABLES '-D' '[::1]'; }
 done
}

##

switch_set(){
if [ -n "${1}" ]; then
 sed -i "/${2}/s/#//g" $CONFIG
 echo "- [${2}] Enable"
else
 sed -i "/${2}/s/^/#&/" $CONFIG
 echo "- [${2}] Disable"
fi
}

core_boot(){
  core_check && killall $CORE_BINARY
  sleep 0.5
  echo "- $(date +'%d: %r') - Start proxy"
  nohup $CORE_PATH -config $CONFIG &
}

###
for opt in $*
do
 case $opt in
  -start)
  iptrules_off
  core_boot
  sleep 9
  if core_check; then
   iptrules_on
  else
   echo 'Fails !'; exit 1
  fi
  ;;
  -start_core)
  core_boot
  sleep 9
  if [ ! core_check ]; then
   echo 'Fails !'; exit 1
  fi
  ;;
  -stop)
  echo '- Stop proxy'
  iptrules_off
  killall $CORE_BINARY
  echo '- Done'
  ;;
  -status)  i=0
  core_check && { echo '< Core Online >'; i=`expr $i + 1`; }||{ echo '! Core Offline !'; }
  iptrules_check && { echo '< iprules Enabled >'; i=`expr $i + 1`; }||{ echo '! iprules Disabled !'; }
  [ $i -lt 2 ] && exit 1
  ;;
  -h|--help)
cat <<EOD
dnsproxy [string]
-start  Start dnscrypt-proxy
-stop  Stop dnscrypt-proxy
-status  Proxy Status
-start_core  Boot core only
--reset  Reset iptables
--switch  Switch set
EOD
  ;;
####
  --reset)
  $IPTABLES -t nat -F OUTPUT
  $IP6TABLES -t raw -F OUTPUT
  echo '- Done'
  ;;
  --switch)
  echo 'list [blacklist, cloak, forward, log, nx, query, whitelist]'
  echo -n "Now select the switch: "
  read -r switch
  case ${switch} in
   blacklist)  switch="blacklist\.txt";;
   cloak)  switch="cloaking_rules";;
   forward)  switch="forwarding_rules";;
   log) switch="dnscrypt-proxy\.log";;
   nx) switch="nx\.log";;
   query)  switch="query\.log";;
   whitelist)  switch="whitelist\.txt";;
   *)  echo "- Invalid input \"${switch}\""; exit 1;;
  esac
  switch_set "`gconf "#.*${switch}"`" $switch
  ;;
  -*)
  echo "- Invalid input \"$opt\""
  exit 1
  ;;
 esac
done
exit 0
