# tips

These are some extra tips, as well as some rationale behind some of the perhaps more invasive decisions I made while trying to prolong battery life.

## alder lake

Alder Lake is disgustingly inefficient by default. However, it doesn't have to be this way, as it is built on both big.LITTLE and a newer fab process.

There are a few reasons to disable e cores over p cores -

* P cores have hyperthreading and therefore can run 2 threads per core
* The system by default starts on a p core, meaning one (of the two) must be running at all times
* P cores are more power efficient when underclocked (as tuned does) due to their optimization for high performance

However, there are also a few reasons to disable p cores -

* P cores tend to ramp in clocks faster
* E cores are more efficient for background tasks
* Running all processes on P cores prevents them from entering sleep when idling

In general, disabling p cores leads to better efficiency while not under load while disabling e cores leads to better efficiency under load. You can choose what you want by modifying the tuned script. By default, it disables e cores.

The tuned script also contains some lines for disabling intel\_pstate, which forcibly locks the cpus to the lowest frequency. This results in a significantly laggier system, but may marginally increase battery life.

Also relevant to Alder Lake is the GRUB settings, which fix some ACPI errors that it likes to spit out.

## xe gpu

The xe driver seems to result in a bit of power saving by itself, but most of the benefits come from the module options.

The driver power saving should be a mode in tuned. It is in TLP, which is where I stole the code from. I don't know how much it does, but it seems to help.

There is some additional info on the linux surface wiki about screen flashing with VRR, but I haven't encountered that yet personally.

## wifi roaming

WiFi roaming seems to cause the kernel scheduler to be triggered extremely often, leading to high cpu times. Apparently, setting a BSSID in NetworkManager disables it. I want WiFi roaming for some SSIDs and no roaming for others, so this solution works well for me.
