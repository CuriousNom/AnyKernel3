# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=N0Kernel by EmanuelCN
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=alioth
device.name2=aliothin
device.name3=
device.name4=
device.name5=
supported.versions=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=1;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 750 750 $ramdisk/*;

# Auto-detect variant from zip name
case "$ZIPFILE" in
  *-5k*)      v=5k;;
  *miui*)     v=miui;;
  *miui-5k*)  v=miui-5k;;
  *N0Kernel*) v=default;;
esac

# Automatic miui detection
region="$(file_getprop /vendor/build.prop "ro.vendor.miui.build.region")"
if [ -z "$region" ]; then
  region="$(file_getprop /product/etc/build.prop "ro.miui.build.region")"
fi
case "$region" in
  cn|in|ru|id|eu|tr|tw|gb|global|mx|jp|kr|lm|cl|mi)
    # If ZIP contains -5k prefer miui-5k, otherwise choose miui
    if echo "${ZIPFILE:-}" | grep -q -- '-5k'; then
      v=miui-5k
      os_string="MIUI ROM with 5K battery"
    else
      v=miui
      os_string="MIUI ROM"
    fi
    ui_print "  -> $os_string is detected!"
    ;;
esac

# If none are detected (adb sideload), let the user pick
if [ -z "$v" ]; then
  set -- 5k miui miui-5k default
  i=1; n=$#
  prev_option=""
  ui_print "Select DTBO variant:"
  while :; do
    eval "current_option=\${$i}"
    # Only print when the option changes
    if [ "$current_option" != "$prev_option" ]; then
      ui_print "> Option selected: $current_option  (Vol–=Next  Vol+=Select)"
      prev_option="$current_option"
    fi
    ev=$(getevent -lc1 2>/dev/null | tr -d '\r')
    case $ev in
      *KEY_VOLUMEDOWN*DOWN*)
        i=$(( i % n + 1 ))
        ;;
      *KEY_VOLUMEUP*DOWN*)
        v="$current_option"
        break
        ;;
    esac
    sleep 0.1
  done
fi

# Select default if still unset
[ -z "$v" ] && v=default

# Apply the right dtbo
ui_print " • Using $v DTBO"
if [ "$v" != default ]; then
  rm -f dtbo.img && mv "$v/dtbo.img" "dtbo.img"
fi

## AnyKernel install
dump_boot;

# Begin Ramdisk Changes

# migrate from /overlay to /overlay.d to enable SAR Magisk
if [ -d $ramdisk/overlay ]; then
  rm -rf $ramdisk/overlay;
fi;

write_boot;
## end install

## vendor_boot shell variables
block=/dev/block/bootdevice/by-name/vendor_boot;
is_slot_device=1;
ramdisk_compression=auto;
patch_vbmeta_flag=auto;

# reset for vendor_boot patching
reset_ak;

# vendor_boot install
dump_boot;

write_boot;
## end vendor_boot install

