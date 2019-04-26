source ${0%/*}/script.constant.sh
conf_path=${CONFIG%/*}
if [ ! -e conf_path/reserved ]
then
  rm -r conf_path
fi
