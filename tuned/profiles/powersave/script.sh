#!/usr/bin/bash

. /usr/lib/tuned/functions

disable_cores() {
    # cpu0 should always be a p core
    cpu0_freq=$(< /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq)
    for dev in /sys/devices/system/cpu/cpu[0-9]*/; do
        # I guess this is the only way to distinguish P-cores?
        maxfreq=$(< $dev/cpufreq/cpuinfo_max_freq)
        # use this line to disable p cores
        #if (( maxfreq >= cpu0_freq)); then
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
    # disabling select cores (except core 0)
    disable_cores
    # disable intel_pstate active mode (stop cpu from throttling up ever)
    #echo "passive" >  /sys/devices/system/cpu/intel_pstate/status
    # now we have to set the governor again because setting this to passive undid it
    #echo "powersave" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
    return 0
}

stop() {
    [ "$USB_AUTOSUSPEND" = 1 ] && disable_usb_autosuspend
    disable_wifi_powersave
    #echo "base" | tee /sys/class/drm/card*/gt/gt0/slpc_power_profile
    echo "base" | tee /sys/class/drm/card?/device/tile*/gt*/freq*/power_profile
    # reenable all cores
    echo 1 | tee /sys/devices/system/cpu/cpu*/online
    # reenable active mode for intel_pstate
    #echo "active" >  /sys/devices/system/cpu/intel_pstate/status
    return 0
}

process $@
