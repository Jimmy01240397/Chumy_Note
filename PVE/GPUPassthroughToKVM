# PVE
## set grub
```
vi /etc/default/grub

GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on video=efifb:off"
```

## update grub and check
```
update-grub
dmesg | grep -e DMAR -e IOMMU
```

## reboot pve

## add VFIO module
```
vi /etc/modules

vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
```

## blacklist GPU modules
```
echo "blacklist radeon" >> /etc/modprobe.d/blacklist.conf
echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf
echo "blacklist nvidia" >> /etc/modprobe.d/blacklist.conf 
echo "blacklist nvidiafb" >> /etc/modprobe.d/blacklist.conf
echo "blacklist i2c_nvidia_gpu" >> /etc/modprobe.d/blacklist.conf
echo "blacklist snd_hda_intel" >> /etc/modprobe.d/blacklist.conf  
echo "blacklist snd_hda_codec_hdmi" >> /etc/modprobe.d/blacklist.conf
echo "blacklist i915" >> /etc/modprobe.d/blacklist.conf
update-initramfs -u 
```

## get your GPU PCI ID
```
root@VASP:~# lspci | grep NVIDIA
af:00.0 VGA compatible controller: NVIDIA Corporation TU102 [GeForce RTX 2080 Ti] (rev a1)
af:00.1 Audio device: NVIDIA Corporation TU102 High Definition Audio Controller (rev a1)
af:00.2 USB controller: NVIDIA Corporation TU102 USB 3.1 Host Controller (rev a1)
af:00.3 Serial bus controller [0c80]: NVIDIA Corporation TU102 USB Type-C UCSI Controller (rev a1)
```
## reboot pve

# setting KVM
## set like this

