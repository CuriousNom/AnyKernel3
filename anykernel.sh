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

ui_print ""
ui_print "  =================================================="
sleep 0.15
ui_print "               n0 Kernel Installer                  "
sleep 0.15
ui_print "  =================================================="
ui_print ""
sleep 0.15
ui_print "    Target Device  : Xiaomi Pad 6 (pipa)"
sleep 0.15
ui_print "    Chipset        : Snapdragon 870"
sleep 0.15
ui_print "    Maintainer     : Aryan (CuriousNom)"
sleep 0.15
ui_print "    Core Dev       : EmanuelCN0 originally for alioth"
ui_print ""
sleep 0.15
ui_print "  --------------------------------------------------"
sleep 0.1
ui_print "       Initializing flash environment..."
ui_print ""
sleep 0.2
ui_print "       Mounting partitions..."
sleep 0.2
ui_print "       Extracting kernel image..."
sleep 0.2
ui_print "       Flashing boot partition..."
sleep 0.2
ui_print ""
ui_print "       n0 Kernel installation in progress"
sleep 0.1
ui_print "  --------------------------------------------------"
ui_print ""

## Prepare Kernel and DTB
mv "$home/kernels/Image" "$home/Image"
mv "$home/kernels/dtb" "$home/dtb"
mv "$home/kernels/dtbo.img" "$home/dtbo.img"

## Boot Partition Flash
split_boot
flash_boot

## Flash DTBO
flash_dtbo

## Vendor Boot Partition Flash
block=vendor_boot
is_slot_device=1
ramdisk_compression=auto
patch_vbmeta_flag=auto

# Reset AnyKernel state for vendor_boot
reset_ak

split_boot
flash_boot

ui_print ""
ui_print "  --------------------------------------------------"
ui_print "         n0 Kernel flashed successfully"
ui_print "            on Xiaomi Pad 6 (pipa)"
ui_print "  --------------------------------------------------"
ui_print ""
ui_print "     You may now reboot your device safely."
ui_print ""
ui_print "  =================================================="
ui_print ""
