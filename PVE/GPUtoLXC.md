# install driver in pve
## add apt mirror
``` bash
vi /etc/apt/sources.list
deb http://deb.debian.org/debian bullseye main contrib non-free

deb http://deb.debian.org/debian-security/ bullseye-security main contrib non-free

deb http://deb.debian.org/debian bullseye-updates main contrib non-free

deb http://deb.debian.org/debian bullseye-backports main contrib non-free
```

## update and full-upgrade

## install pve-header
``` bash
apt-get install pve-headers-<your kernal version>-pve 
```

## install dkms
``` bash
apt-get install dkms
```

## check
``` bash
lspci | grep -i nvidia
lspci -vvv |grep -i -A 20 nvidia
```

## install driver
``` bash
apt-get install -t bullseye-backports nvidia-driver nvidia-smi
```

## add modules
``` bash
vi /etc/modules-load.d/nvidia.conf

nvidia-drm
nvidia
nvidia_uvm

blacklist nouveau
blacklist nvidiafb
```
``` bash
update-initramfs -u -k all
```

## add rules
``` bash
vi /etc/udev/rules.d/70-nvidia.rules
KERNEL=="nvidia", RUN+="/bin/bash -c '/usr/bin/nvidia-smi -L && /bin/chmod 666 /dev/nvidia*'"
KERNEL=="nvidia_uvm", RUN+="/bin/bash -c '/usr/bin/nvidia-modprobe -c0 -u && /bin/chmod 0666 /dev/nvidia-uvm*'"
```

## reboot pve

## check and remember 3 important number, in this case is 195, 508, 226
``` bash
root@pve:~# ls -al /dev/nvidia*
crw-rw-rw- 1 root root 195,   0 Jan 22 19:42 /dev/nvidia0
crw-rw-rw- 1 root root 195, 255 Jan 22 19:42 /dev/nvidiactl
crw-rw-rw- 1 root root 195, 254 Jan 22 19:42 /dev/nvidia-modeset
crw-rw-rw- 1 root root 508,   0 Jan 22 19:42 /dev/nvidia-uvm
crw-rw-rw- 1 root root 508,   1 Jan 22 19:42 /dev/nvidia-uvm-tools

/dev/nvidia-caps:
total 0
drw-rw-rw-  2 root root     80 Jan 22 19:42 .
drwxr-xr-x 23 root root   4760 Jan 23 01:11 ..
cr--------  1 root root 238, 1 Jan 22 19:42 nvidia-cap1
cr--r--r--  1 root root 238, 2 Jan 22 19:42 nvidia-cap2
root@pve:~# ls -al /dev/dri/*
crw-rw---- 1 root video  226,   0 Jan 22 19:42 /dev/dri/card0
crw-rw---- 1 root video  226,   1 Jan 22 19:42 /dev/dri/card1
crw-rw---- 1 root render 226, 128 Jan 22 19:42 /dev/dri/renderD128

/dev/dri/by-path:
total 0
drwxr-xr-x 2 root root 100 Jan 22 19:42 .
drwxr-xr-x 3 root root 120 Jan 22 19:42 ..
lrwxrwxrwx 1 root root   8 Jan 22 19:42 pci-0000:03:00.0-card -> ../card0
lrwxrwxrwx 1 root root   8 Jan 22 19:42 pci-0000:af:00.0-card -> ../card1
lrwxrwxrwx 1 root root  13 Jan 22 19:42 pci-0000:af:00.0-render -> ../renderD128
root@pve:~# nvidia-smi
Sun Jan 23 01:24:44 2022       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 470.94       Driver Version: 470.94       CUDA Version: 11.4     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  NVIDIA GeForce ...  On   | 00000000:AF:00.0 Off |                  N/A |
| 27%   28C    P8     1W / 250W |      1MiB / 11019MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+
```

# setting LXC
## boot LXC and apt update and full-upgrade
## download your driver installer from nvidia the use the same version with pve, in this case is 470.94. (check with nvidia-smi)
``` bash
wget http://us.download.nvidia.com/XFree86/Linux-x86_64/<your driver version>/NVIDIA-Linux-x86_64-<your driver version>.run
```
## install driver
``` bash
bash NVIDIA-Linux-x86_64-<your driver version>.run --no-kernel-module
```
## shutdown your LXC and goto pve. set your LXC conf. add your [3 important numbers that you get befor](#check-and-remember-3-important-number-in-this-case-is-195-508-226)
``` bash
vi /etc/pve/lxc/<LXC ID>.conf
lxc.cgroup.devices.allow: c 195:* rwm
lxc.cgroup.devices.allow: c 508:* rwm
lxc.cgroup.devices.allow: c 226:* rwm
lxc.mount.entry: /dev/nvidia0 dev/nvidia0 none bind,optional,create=file
lxc.mount.entry: /dev/nvidiactl dev/nvidiactl none bind,optional,create=file
lxc.mount.entry: /dev/nvidia-uvm dev/nvidia-uvm none bind,optional,create=file
lxc.mount.entry: /dev/nvidia-modeset dev/nvidia-modeset none bind,optional,create=file
lxc.mount.entry: /dev/nvidia-uvm-tools dev/nvidia-uvm-tools none bind,optional,create=file
lxc.mount.entry: /dev/dri dev/dri none bind,optional,create=dir
```

## boot your LXC and you can check with nvidia-smi
``` bash
nvidia-smi
```

# install cuda
## install packages
``` bash
apt-get install gcc g++ freeglut3-dev build-essential libx11-dev libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev
```

## download cuda install from nvidia the use the same version with [nvidia-smi that you saw befor](#boot-your-LXC-and-you-can-check-with-nvidia-smi)
``` bash
wget https://developer.download.nvidia.com/compute/cuda/11.4.3/local_installers/cuda_11.4.3_470.82.01_linux.run
```

## install cuda and don't install driver
``` bash
bash cuda_11.4.3_470.82.01_linux.run
┌──────────────────────────────────────────────────────────────────────────────┐
│  End User License Agreement                                                  │
│  --------------------------                                                  │
│                                                                              │
│  NVIDIA Software License Agreement and CUDA Supplement to                    │
│  Software License Agreement. Last updated: October 8, 2021                   │
│                                                                              │
│  The CUDA Toolkit End User License Agreement applies to the                  │
│  NVIDIA CUDA Toolkit, the NVIDIA CUDA Samples, the NVIDIA                    │
│  Display Driver, NVIDIA Nsight tools (Visual Studio Edition),                │
│  and the associated documentation on CUDA APIs, programming                  │
│  model and development tools. If you do not agree with the                   │
│  terms and conditions of the license agreement, then do not                  │
│  download or use the software.                                               │
│                                                                              │
│  Last updated: October 8, 2021.                                              │
│                                                                              │
│                                                                              │
│  Preface                                                                     │
│  -------                                                                     │
│                                                                              │
│──────────────────────────────────────────────────────────────────────────────│
│ Do you accept the above EULA? (accept/decline/quit):                         │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
accept
┌──────────────────────────────────────────────────────────────────────────────┐
│ CUDA Installer                                                               │
│ - [ ] Driver                                                                 │
│      [ ] 470.82.01                                                           │
│ + [X] CUDA Toolkit 11.4                                                      │
│   [X] CUDA Samples 11.4                                                      │
│   [X] CUDA Demo Suite 11.4                                                   │
│   [X] CUDA Documentation 11.4                                                │
│   Options                                                                    │
│   Install                                                                    │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│ Up/Down: Move | Left/Right: Expand | 'Enter': Select | 'A': Advanced options │
└──────────────────────────────────────────────────────────────────────────────┘
```
## goto /etc/profile add PATH=/usr/local/cuda-11.4/bin:$PATH and add /usr/local/cuda-11.4/lib64 to /etc/ld.so.conf.d/cuda-11-4.conf and run ldconfig as root.
## check with nvcc -V
``` bash
nvcc -V
```

## testing
``` bash
cuda-install-samples-11.4.sh ~

cd ~/NVIDIA_CUDA-11.4_Samples/5_Simulations/nbody

sudo apt-get install libglu1-mesa libxi-dev libxmu-dev libglu1-mesa-dev

sudo apt-get install freeglut3-dev build-essential libx11-dev libxmu-dev libxi-dev libgl1-mesa-glx libglu1-mesa libglu1-mesa-dev libglfw3-dev libgles2-mesa-dev

GLPATH=/usr/lib make

./nbody numdevices=1 -benchmark
```
``` bash
root@VASP:~/NVIDIA_CUDA-11.4_Samples/5_Simulations/nbody# ./nbody numdevices=1 -benchmark
Run "nbody -benchmark [-numbodies=<numBodies>]" to measure performance.
        -fullscreen       (run n-body simulation in fullscreen mode)
        -fp64             (use double precision floating point values for simulation)
        -hostmem          (stores simulation data in host memory)
        -benchmark        (run benchmark to measure performance) 
        -numbodies=<N>    (number of bodies (>= 1) to run in simulation) 
        -device=<d>       (where d=0,1,2.... for the CUDA device to use)
        -numdevices=<i>   (where i=(number of CUDA devices > 0) to use for simulation)
        -compare          (compares simulation results running once on the default GPU and once on the CPU)
        -cpu              (run n-body simulation on the CPU)
        -tipsy=<file.bin> (load a tipsy model file for simulation)

NOTE: The CUDA Samples are not meant for performance measurements. Results may vary when GPU Boost is enabled.

number of CUDA devices  = 1
> Windowed mode
> Simulation data stored in video memory
> Single precision floating point simulation
> 1 Devices used for simulation
GPU Device 0: "Turing" with compute capability 7.5

> Compute 7.5 CUDA device: [NVIDIA GeForce RTX 2080 Ti]
69632 bodies, total time for 10 iterations: 113.990 ms
= 425.354 billion interactions per second
= 8507.071 single-precision GFLOP/s at 20 flops per interaction
```
