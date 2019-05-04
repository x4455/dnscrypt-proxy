#!/system/bin/sh
MODPATH=/data/adb/modules/dnscrypt-proxy
source $MODPATH/constant.sh
conf_path=${CONFIG%/*}
if [ ! -e conf_path/reserved ]
then
  rm -r conf_path
fi
