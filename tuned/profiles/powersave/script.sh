#!/usr/bin/bash

. /usr/lib/tuned/functions

disable_e_cores() {
    # cpu0 should always be a p core
    cpu0_freq=$(< /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq)
    for dev in /sys/devices/system/cpu/cpu[0-9]*/; do
        # I guess this is the only way to distinguish P-cores?
        maxfreq=$(< $dev/cpufreq/cpuinfo_max_freq)
        if (( maxfreq < cpu0_freq )); then
            echo 0 > $dev/online
        fi
    done
}

start() {
    [ "$USB_AUTOSUSPEND" = 1 ] && enable_usb_autosuspend
    enable_wifi_powersave
    # use this line for i915, use enabled line for xe driver
    #echo "power_saving" | tee /sys/class/drm/card?/gt/gt0/slpc_power_profile
    echo "power_saving" | tee /sys/class/drm/card?/device/tile*/gt*/freq*/power_profile
    # disabling e cores
    disable_e_cores
    # /sys/devices/system/cpu/cpu*/cpufreq/cpuinfo_max_freq
    return 0
}

stop() {
    [ "$USB_AUTOSUSPEND" = 1 ] && disable_usb_autosuspend
    disable_wifi_powersave
    #echo "base" | tee /sys/class/drm/card*/gt/gt0/slpc_power_profile
    echo "base" | tee /sys/class/drm/card?/device/tile*/gt*/freq*/power_profile
    # reenable all cores
    echo 1 | tee /sys/devices/system/cpu/cpu*/online
    return 0
}

process $@
