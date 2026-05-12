# tips

These are some extra tips, as well as some rationale behind some of the perhaps more invasive decisions I made while trying to prolong battery life.

## alder lake

Alder Lake is disgustingly inefficient by default. However, it doesn't have to be this way, as it is built on both big.LITTLE and a newer fab process.

Disabling e cores is more efficient than disabling p cores for a few reasons -

* P cores have hyperthreading and therefore can run 2 threads per core
* The system by default starts on a p core, meaning one (of the two) must be running at all times
* P cores are more power efficient when underclocked (as tuned does) due to their optimization for high performance

As such, I configured the low power mode to also disable the e cores entirely. The more observative of you all may realize that this effectively turns the CPU into an 11th gen i5. That may be true, but in this case its not a bad thing.

Also relevant to Alder Lake is the GRUB settings, which fix some ACPI errors that it likes to spit out.

## xe gpu

The xe driver seems to result in a bit of power saving by itself, but most of the benefits come from the module options.

The driver power saving should be a mode in tuned. It is in TLP, which is where I stole the code from. I don't know how much it does, but it seems to help.

There is some additional info on the linux surface wiki about screen flashing with VRR, but I haven't encountered that yet personally.

## wifi roaming

WiFi roaming seems to cause the kernel scheduler to be triggered extremely often, leading to high cpu times. Apparently, setting a BSSID in NetworkManager disables it. I want WiFi roaming for some SSIDs and no roaming for others, so this solution works well for me.
