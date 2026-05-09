#!/usr/bin/bash

. /usr/lib/tuned/functions

start() {
    [ "$USB_AUTOSUSPEND" = 1 ] && enable_usb_autosuspend
    enable_wifi_powersave
    # use this line for i915, use enabled line for xe driver
    #echo "power_saving" | tee /sys/class/drm/card?/gt/gt0/slpc_power_profile
    echo "power_saving" | tee /sys/class/drm/card?/device/tile*/gt*/freq*/power_profile
    return 0
}

stop() {
    [ "$USB_AUTOSUSPEND" = 1 ] && disable_usb_autosuspend
    disable_wifi_powersave
    #echo "base" | tee /sys/class/drm/card*/gt/gt0/slpc_power_profile
    echo "base" | tee /sys/class/drm/card?/device/tile*/gt*/freq*/power_profile
    return 0
}

process $@
