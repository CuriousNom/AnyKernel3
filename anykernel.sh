# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
  do.devicecheck=0
  do.modules=0
  do.systemless=1
  do.cleanup=1
  do.cleanuponabort=0
  device.name1=pipa
  supported.versions=
  supported.patchlevels=
'; } # end properties

# shell variables
block=boot
is_slot_device=auto
ramdisk_compression=auto
patch_vbmeta_flag=auto
no_block_display=1

## Import AnyKernel core functions
. tools/ak3-core.sh

## Detect ROM Flavor
userflavor="$(file_getprop /system/build.prop ro.build.flavor)"
case "$userflavor" in
    aospa_pipa-user) os="aospa"; os_string="Paranoid Android ROM";;
    *)              os="aosp";  os_string="AOSP ROM";;
esac
ui_print "  -> ${os_string} detected!"
ui_print ""
ui_print "  =================================================="
ui_print "              BloodReaper Kernel Installer          "
ui_print "  =================================================="
ui_print ""
ui_print "    Target Device  : Xiaomi Pad 6 (pipa)"
ui_print "    Chipset        : Snapdragon 870"
ui_print "    Maintainer     : Aryan (CuriousNom)"
ui_print ""
ui_print "  --------------------------------------------------"
ui_print "       Initializing flash environment..."
ui_print ""
ui_print "       Mounting partitions..."
ui_print "       Extracting kernel image..."
ui_print "       Flashing boot partition..."
ui_print ""
ui_print "       BloodReaper Kernel installation in progress"
ui_print "  --------------------------------------------------"
ui_print ""

## Prepare Kernel DTB DTBO
mv "$home/kernels/Image" "$home/Image"
mv "$home/kernels/dtb" "$home/dtb"
mv "$home/kernels/dtbo.img $home/dtbo.img"

## Boot Partition
split_boot
flash_boot

## vendor_boot shell variable
block=vendor_boot
is_slot_device=1
ramdisk_compression=auto
patch_vbmeta_flag=auto

# Reset AnyKernel state for vendor_boot
reset_ak

# Flash vendor boot
split_boot
flash_boot

# Flash DTBO
flash_dtbo

ui_print ""
ui_print "  --------------------------------------------------"
ui_print "       BloodReaper Kernel flashed successfully"
ui_print "            on Xiaomi Pad 6 (pipa)"
ui_print "  --------------------------------------------------"
ui_print ""
ui_print "     You may now reboot your device safely."
ui_print "     Thank you for choosing BloodReaper."
ui_print ""
ui_print "  =================================================="
ui_print ""
