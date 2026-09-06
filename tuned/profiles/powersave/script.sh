#!/usr/bin/bash

. /usr/lib/tuned/functions

kscreen_doctor() {
    local target_mode="$1"
    # get all users with graphical session (seatX)
    local graphical_users="$(loginctl list-sessions | grep -oP '(\S+)(?= seat\d+)' | sort -u)"
    for user in $graphical_users; do
        # make sure that the user has DISPLAY, WAYLAND_DISPLAY, and XAUTHORITY in their systemd
        # run "systemctl --user import-environment WAYLAND_DISPLAY DISPLAY XAUTHORITY" at startup
        # have to run this in another systemd-run due to bs dbus errors
        systemd-run systemd-run --user --machine=$user@ kscreen-doctor "output.eDP-1.mode.$target_mode" 2&> /dev/null
    done
}

set_rapl_limit() {
    local rapl_dev=""
    for rapl in $(ls -d /sys/class/powercap/intel-rapl:*); do
        if [ $(cat "$rapl/name") = $1 ]; then
            rapl_dev=$rapl
            break
        fi
    done
    if [ -z $rapl_dev ]; then
        return 0
    fi
    echo $2 | tee $rapl_dev/constraint_0_power_limit_uw
    if [ -n "$3" ]; then
        echo $3 | tee $rapl_dev/constraint_1_power_limit_uw
    else
        echo $2 | tee $rapl_dev/constraint_1_power_limit_uw
    fi
}

start() {
    enable_usb_autosuspend
    enable_wifi_powersave
    set_hda_intel_powersave 1
    enable_cpu_multicore_powersave
    # use this line for i915, use enabled line for xe driver
    #echo "power_saving" | tee /sys/class/drm/card?/gt/gt0/slpc_power_profile
    echo "power_saving" | tee /sys/class/drm/card?/device/tile*/gt*/freq*/power_profile
    # set screen to 60Hz
    kscreen_doctor 2880x1920@60
    # PCIe stuff
    echo "powersupersave" | tee /sys/module/pcie_aspm/parameters/policy
    echo 1 | tee /sys/bus/pci/devices/*/power/control
    set_rapl_limit package-0 10000000 13000000
    return 0
}

stop() {
    disable_usb_autosuspend
    disable_wifi_powersave
    restore_hda_intel_powersave 10
    disable_cpu_multicore_powersave
    #echo "base" | tee /sys/class/drm/card*/gt/gt0/slpc_power_profile
    echo "base" | tee /sys/class/drm/card?/device/tile*/gt*/freq*/power_profile
    # go back to 120Hz
    kscreen_doctor 2880x1920@120
    echo "default" | tee /sys/module/pcie_aspm/parameters/policy
    # no need to undo enabling runtime PM
    #echo 1 | tee /sys/bus/pci/devices/*/power/control
    set_rapl_limit package-0 35000000 60000000
    return 0
}

process $@
