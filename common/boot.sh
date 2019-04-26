#!/system/bin/sh
# Script by x4455 @ github
MODDIR=${0%/*}
RETRY_INTERVAL=10 #seconds
MAX_RETRY=6
retry=${MAX_RETRY}

while (("$retry" > "0")) || [ "`getprop init.svc.bootanim`" != "stopped" ]; do
 sleep ${RETRY_INTERVAL}
 ((retry--))
done

log() {
source $MODDIR/script.constant.sh
LOG_PATH="${CONFIG%/*}/boot.log"
[ -f $LOG_PATH ] \
  && mv $LOG_PATH $LOG_PATH.old
echo "Service Start - $(date +'%d/ %r')">$LOG_PATH
exec 1>>$LOG_PATH 2>&1
set -x
}
log

for retry in 0 1 2 3 4 5 6 7 8 9
do
 ping -c 1 download.dnscrypt.info
 if [[ $? == 0 ]];	then
  /system/bin/sh /system/xbin/dnsproxy -start
  break;
 else
  sleep 10
 fi
done
exit 0
