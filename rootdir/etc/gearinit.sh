#!/system/xbin/busybox sh

if [ ! -f "/system/etc/gearcm" ]
then
   echo "Wrong ROM, reboot...";
   reboot recovery;
else
   echo "This is GearCM, continue...";
fi

# Mount / as RW
mount -t rootfs -o remount,rw rootfs

# Initialize Synapse
chown -R root.root /res/synapse
chmod -R 777 /res/synapse
ln -s /res/synapse/uci /sbin/uci
/sbin/uci

# Initialize Wolfson Sound Control
echo "0x0FA4 0x0404 0x0170 0x1DB9 0xF233 0x040B 0x08B6 0x1977 0xF45E 0x040A 0x114C 0x0B43 0xF7FA 0x040A 0x1F97 0xF41A 0x0400 0x1068" > /sys/class/misc/wolfson_control/eq_sp_freqs
echo -5 > /sys/class/misc/wolfson_control/eq_sp_gain_1
echo 1 > /sys/class/misc/wolfson_control/eq_sp_gain_2
echo 0 > /sys/class/misc/wolfson_control/eq_sp_gain_3
echo 4 > /sys/class/misc/wolfson_control/eq_sp_gain_4
echo 3 > /sys/class/misc/wolfson_control/eq_sp_gain_5

echo 1 > /sys/class/misc/wolfson_control/switch_eq_speaker

# PVR GPU Tweaks
echo 0 > /sys/module/pvrsrvkm/parameters/gPVRDebugLevel

# Restore WiFi PSM Flag
echo 0 > /data/.psm.info

# Mount /system as RW
mount -w -o remount /system

# Initialize SuperSU
set -e

if [[ -f "/system/bin/mksh" ]]; then
    cp -p "/system/bin/mksh" "/system/xbin/sugote-mksh"
else
    cp -p "/system/bin/sh" "/system/xbin/sugote-mksh"
fi

mkdir -p "/system/bin/.ext"
chmod 0777 "/system/bin/.ext"
cp -p "/system/xbin/su" "/system/bin/.ext/.su"

rm -f "/system/bin/app_process"
ln -s "/system/xbin/daemonsu" "/system/bin/app_process"

for BIT in "64" "32"; do
    if [[ -f "/system/bin/app_process${BIT}" ]]; then
        if [[ ! -f "/system/bin/app_process${BIT}_original" ]]; then
            mv "/system/bin/app_process${BIT}" "/system/bin/app_process${BIT}_original"
            ln -s "/system/xbin/daemonsu" "/system/bin/app_process${BIT}"
        fi
        if [[ ! -f "/system/bin/app_process_init" ]]; then
            cp -p "/system/bin/app_process${BIT}_original" "/system/bin/app_process_init"
        fi
    fi
done

chcon u:object_r:system_file:s0 /system/app/SuperSU/SuperSU.apk
chcon u:object_r:toolbox_exec:s0 /system/etc/install-recovery.sh
chcon u:object_r:system_file:s0 /system/bin/.ext/.su
chcon u:object_r:system_file:s0 /system/xbin/daemonsu
chcon u:object_r:zygote_exec:s0 /system/xbin/sugote
chcon u:object_r:system_file:s0 /system/xbin/supolicy
chcon u:object_r:system_file:s0 /system/lib/libsupol.so
chcon u:object_r:system_file:s0 /system/xbin/sugote-mksh
chcon u:object_r:zygote_exec:s0 /system/bin/app_process32_original
chcon u:object_r:system_file:s0 /system/bin/app_process_init
chcon u:object_r:system_file:s0 /system/etc/init.d/99SuperSUDaemon
chcon u:object_r:system_file:s0 /system/etc/.installed_su_daemon
chcon u:object_r:system_file:s0 /system/xbin/su

/system/etc/init.d/99SuperSUDaemon

exit 0
