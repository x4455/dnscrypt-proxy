
##########################################################################################
# Config Flags
##########################################################################################

# Set to true if you do *NOT* want Magisk to mount
# any files for you.
SKIPMOUNT=false

# Set to true if you need to load system.prop
PROPFILE=false

# Set to true if you need post-fs-data script
POSTFSDATA=false

# Set to true if you need late_start service script
LATESTARTSERVICE=true

##########################################################################################
# Replace list
##########################################################################################

# List all directories you want to directly replace in the system
# Check the documentations for more info why you would need this

# Construct your own list here
REPLACE="
"

##########################################################################################
#
# Function Callbacks
#
# The following functions will be called by the installation framework.
# You do not have the ability to modify update-binary, the only way you can customize
# installation is through implementing these functions.
#
# When running your callbacks, the installation framework will make sure the Magisk
# internal busybox path is *PREPENDED* to PATH, so all common commands shall exist.
# Also, it will make sure /data, /system, and /vendor is properly mounted.
#
##########################################################################################
##########################################################################################
#
# Available variables:
#
# MAGISK_VER (string): the version string of current installed Magisk
# MAGISK_VER_CODE (int): the version code of current installed Magisk
# BOOTMODE (bool): true if the module is currently installing in Magisk Manager
# MODPATH (path): the path where your module files should be installed
# TMPDIR (path): a place where you can temporarily store files
# ZIPFILE (path): your module's installation zip
# ARCH (string): the architecture of the device. Value is either arm, arm64, x86, or x64
# IS64BIT (bool): true if $ARCH is either arm64 or x64
# API (int): the API level (Android version) of the device
#
# Availible functions:
#
# ui_print <msg>
#     print <msg> to console
#     Avoid using 'echo' as it will not display in custom recovery's console
#
# abort <msg>
#     print error message <msg> to console and terminate installation
#     Avoid using 'exit' as it will skip the termination cleanup steps
#
# set_perm <target> <owner> <group> <permission> [context]
#     if [context] is empty, it will default to "u:object_r:system_file:s0"
#     this function is a shorthand for the following commands
#       chown owner.group target
#       chmod permission target
#       chcon context target
#
# set_perm_recursive <directory> <owner> <group> <dirpermission> <filepermission> [context]
#     if [context] is empty, it will default to "u:object_r:system_file:s0"
#     for all files in <directory>, it will call:
#       set_perm file owner group filepermission context
#     for all directories in <directory> (including itself), it will call:
#       set_perm dir owner group dirpermission context
#
##########################################################################################
##########################################################################################
# If you need boot scripts, DO NOT use general boot scripts (post-fs-data.d/service.d)
# ONLY use module scripts as it respects the module status (remove/disable) and is
# guaranteed to maintain the same behavior in future Magisk releases.
# Enable boot scripts by setting the flags in the config section above.
##########################################################################################

# Set what you want to display when installing your module

version=$(grep_prop version $TMPDIR/module.prop | awk -F " " '{print $1}')
print_modname() {
  ui_print "*******************************"
  ui_print " DNSCrypt-Proxy 2"
  ui_print " $version"
  ui_print " By x4455" 
  ui_print "*******************************"
}

on_install() {
  # The following is the default implementation: extract $ZIPFILE/system to $MODPATH
  # Extend/change the logic to whatever you want
  ui_print "- Extracting module files"
  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2

  [ $API -ge 28 ] && {
  ui_print "***************"
  ui_print '(!) Please close the Private DNS to prevent conflict'
  ui_print "***************"
  }

  imageless_magisk && { OLDDIR="$NVBASE/modules/$MODID"; }||{ OLDDIR="/sbin/.magisk/img/$MODID"; }

  install_dnscrypt_proxy
}


install_dnscrypt_proxy() {
  case $ARCH in
  arm|arm64|x86|x64)
    BINARY_PATH=$TMPDIR/dnscrypt-proxy-$ARCH;;
  *)
    abort "(!) $ARCH are unsupported architecture"
  esac

  unzip -oj "$ZIPFILE" 'binary/*' -d $TMPDIR >&2
  CONSTANT="$OLDDIR/constant.sh"
  [ -e $CONSTANT ] && { source $CONSTANT; }||{ source $TMPDIR/constant.sh; CONSTANT=$TMPDIR/constant.sh; }

  OLD_CONFIG_PATH=${CONFIG%/*}
  NEW_CONFIG_PATH=$OLD_CONFIG_PATH
  EXAMPLE_CONFIG_PATH=$TMPDIR/config
  LISTEN_PORT=5354

  unzip -o "$ZIPFILE" 'config/*' -d $TMPDIR >&2

  mkdir -p $MODPATH/system/xbin 2>/dev/null

  if [ -f "$BINARY_PATH" ]; then
    ui_print "- Architecture: [$ARCH]"
    set_perm $BINARY_PATH 0 0 0755
    ver=$($BINARY_PATH -v)
    ver=$($BINARY_PATH -version)
    ui_print "- Core version: [$ver]"
    sed -i -e "s/<VER>/${ver}-${ARCH}/g" $TMPDIR/module.prop
  else
    abort "(!) $ARCH Binary file missing"
  fi
  ui_print "***************"
# Config
  if [ ! -d "$EXAMPLE_CONFIG_PATH" ]; then
    abort "(!) Example config file is missing"
  fi
  if [ $(ls $OLD_CONFIG_PATH | wc -l) -eq 0 ]; then
    NEW_INSTALL=true
    ui_print "- Create config path"
    mkdir -p $NEW_CONFIG_PATH 2>/dev/null
    ui_print "- Copy the example config file"
    cp -rf $EXAMPLE_CONFIG_PATH/* $NEW_CONFIG_PATH
    cp -f $EXAMPLE_CONFIG_PATH/example-dnscrypt-proxy.toml $NEW_CONFIG_PATH/dnscrypt-proxy.toml
  else
    cp -f $EXAMPLE_CONFIG_PATH/example-dnscrypt-proxy.toml $NEW_CONFIG_PATH/example-dnscrypt-proxy.toml
  fi
# Set files
  cp -af $CONSTANT $MODPATH/constant.sh
  sed -i -e "s/\(^MODPATH\=\).*$/\1${OLDDIR//\//\\\/}/" $TMPDIR/script.sh
  cp -af $TMPDIR/script.sh $MODPATH/system/xbin/dnsproxy
  cp -af $BINARY_PATH $MODPATH/$CORE_BINARY
  [ $NEW_INSTALL == "true" ] && {
  sed -i -e "s/127.0.0.1:53/127.0.0.1:${LISTEN_PORT}/g" $NEW_CONFIG_PATH/dnscrypt-proxy.toml;
  sed -i -e "s/\[::1\]:53/\[::1\]:${LISTEN_PORT}/g" $NEW_CONFIG_PATH/dnscrypt-proxy.toml; }

  if [ ! -L $OLD_CONFIG_PATH/constant.conf ]; then
    ln -s $MODPATH/constant.sh $NEW_CONFIG_PATH/constant.conf
  fi

# Set boot
source $TMPDIR/selector.sh
ui_print " "
ui_print "- Start after boot, Yes or No?"
ui_print " Vol Key+ = Yes"
ui_print " Vol Key- = No"
ui_print " "

if $VKSEL; then
  ui_print "(i) Mod will start after boot."
else
  ui_print "(i) Mod will not start after boot."
  LATESTARTSERVICE=false
fi
ui_print " "
}


set_permissions() {
  # The following is the default rule, DO NOT remove
  set_perm_recursive $MODPATH 0 0 0755 0644
  set_perm $MODPATH/$CORE_BINARY 0 2000 0755
  set_perm_recursive $MODPATH/system/xbin 0 0 0755 0755

  # Here are some examples:
  # set_perm_recursive  $MODPATH/system/lib       0     0       0755      0644
  # set_perm  $MODPATH/system/bin/app_process32   0     2000    0755      u:object_r:zygote_exec:s0
  # set_perm  $MODPATH/system/bin/dex2oat         0     2000    0755      u:object_r:dex2oat_exec:s0
  # set_perm  $MODPATH/system/lib/libart.so       0     0       0644
}
