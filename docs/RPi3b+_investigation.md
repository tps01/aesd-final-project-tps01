# RPi3b+ Investigation
These are my notes/ plan for how to use the peripherals onboard the Raspberry Pi3b+.
For AESD final project purposes, this is related to https://github.com/users/tps01/projects/1?pane=issue&itemId=208674075&issue=tps01%7Caesd-final-project-tps01%7C2

To keep scope constrained, since I only have 3 total sprints, this will start off only concerning GPIO & HDMI. 
I picked these because I anticipate HDMI can simply be tested via some config mechanism (i.e. just plug in a monitor- that's advanced enough under the hood to prove the interface works), and I'll need to write a more involved testing application to excercise the GPIO header in the manner I want. This is where the complexity of this project lies.

## GPIO
Background: It seems as though GPIO support in the linux kernel has had somewhat of a tumultuous history, to say the least. That said, there appears to be one prevailing supported kernel library: a character device implementation, accessible in userspace via <..linux/gpio.h>. Fortunately, this kernel library appears to support my needs (event detection, support of the broadcom chip on the RPi3B+, etc). It also has some additional supporting debug tools, such as libgpiod, which I can install in my image to help work through implementation. (These are not a part of the kernel, of course. They just interact with the library userspace API)

Plan: Write my C GPIO loopback program to interface with the kernel's character device. At a high level, I will need to do the following:

- create an input and output buffer to house the pseudorandom sequence(s) and the read values from looped back pins
- spin up a send and receive thread
- One challenge will be the lack of a dedicated clock line. That is, how can I be sure that the receive pin is reading at the correct time, and didn't miss an event?
- My quick solution will be a mutex, where the sender holds the lock while setting a value, releases it, and the receiver holds the lock while reading off the value. It then gives the lock back to the sender, and the cycle repeats until done. I'll need to be cognizant of the fact that values may never get physically realized as voltages on the board, due to manufacturing defects. This means an event-driven approach would be somewhat risky. That risk could be mitigated via timeouts, or just by simply reading and writing at set times with the mutex approach.
Additional reasoning: While I could write my own kernel GPIO driver for the Broadcom 2837B0 chip, this would essentially be duplicating work that is already done. (It already has support). For the sake of this project, I'd rather gain experience working with this userspace gpio char device, as well as libgpiod. I've seen both of these used at my day job, and gaining some familiarity with them would be valuable in my case. For something like a TnD build, the easier the debug tools are to use, the better.

## HDMI
meta-raspberrypi documentation:
- https://meta-raspberrypi.readthedocs.io/en/latest/extra-build-config.html#hdmi-and-composite-video-options

Fortunately, this mostly turned out to be a part of the default configuration in meta-raspberrypi.
Though the documentation was not perfect, looking through /boot/config.txt on the device itself had the following lines:

```bash
# Enable VC4 Graphics
dtoverlay=vc4-fkms-v3d

# have a properly sized image
disable_overscan=1
```

It also has these options:
```bash
#hdmi_safe=1
#hdmi_ignore_edid=0xa5000080
#hdmi_edid_file=1
#hdmi_force_edid_audio=1
#hdmi_ignore_edid_audio=1
#hdmi_force_edid_3d=1
#avoid_edid_fuzzy_match=1
#hdmi_ignore_cec_init=1
#hdmi_ignore_cec=1
#hdmi_pixel_encoding=1
#hdmi_blanking=1
#hdmi_drive=2
#config_hdmi_boost=0
#hdmi_group=1
#hdmi_mode=1
#hdmi_force_mode=1
#hdmi_force_hotplug=1
#hdmi_ignore_hotplug=1
```

Of these, meta-raspberrypi supports the following in local.conf: `HDMI_FORCE_HOTPLUG`, `HDMI_DRIVE`, `HDMI_GROUP`, `HDMI_MODE`, `HDMI_CVT`, `CONFIG_HDMI_BOOST`, `SDTV_MODE`, `SDTV_ASPECT` and `DISPLAY_ROTATE`.

For this project, I'd like to also enable hot plug. This is a simple local.conf change. The raspberrypi logo that gets displayed on boot is actually a somewhat decent functional test for a board in manufacturing.
More thorough tests would be performed during board design, such as displaying a video. This can be investigated in sprint 3 as an enhancement, if time permits.
Such a task would be relatively straightforward. 
- prepare a test video to run 
  - either bake it into the image (if small), or scp it onto the board if larger
- choose a simple video player like [mpv](https://github.com/mpv-player/mpv) to bake into the build
  - VLC is also seemingly natively supported by meta-raspberrypi
- include a test script either on the board or the test PC.


## Ethernet
Note that while I'm going to test the ethernet capability of the board via iPerf, the ethernet port is already functioning in my base image. This is standard per the defaults of meta-raspberrypi.
While there is some work to add iPerf to the image & create an init script to start it on boot, this is unrelated to this investigation.