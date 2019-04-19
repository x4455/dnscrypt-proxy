#!/system/bin/sh
MODDIR=${0%/*}
#Prevent the subsequent service.sh from affecting the operation
/system/bin/sh $MODDIR/boot.sh &
