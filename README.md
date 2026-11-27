# NVIDIA GTX 970 GPU Passthrough (Arch Linux, AMD)

Isolate the GTX 970 with `vfio-pci` so a VM can use it, while the host keeps using the RTX 3080 Ti.

## Requirements

- Enable **IOMMU** and **SVM Mode** (virtualization) in the ASUS BIOS. Menu names vary by board.
- Find your GPU's PCI IDs (vendor:device) with:

  ```bash
  lspci -nn | grep -i nvidia
  ```

  For the GTX 970 these are `10de:13c2` (GPU) and `10de:0fbb` (HDMI audio).

## 1. Kernel parameters

Edit `/etc/default/grub`:

```bash
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet amd_iommu=on vfio-pci.ids=10de:13c2,10de:0fbb"
```

- `amd_iommu=on` enables the IOMMU. Use `intel_iommu=on` on Intel.
- `vfio-pci.ids=...` makes `vfio-pci` claim both functions at boot.
- Do not put a space after the comma in the ID list.

Regenerate the GRUB config:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

## 2. Modprobe config

Create `/etc/modprobe.d/vfio.conf`:

```bash
sudo nvim /etc/modprobe.d/vfio.conf
```

```conf
options vfio-pci ids=10de:13c2,10de:0fbb
softdep nvidia pre: vfio-pci
```

## 3. Load vfio early in the initramfs

In `/etc/mkinitcpio.conf`, make sure the modules are listed and `modconf` is in `HOOKS`:

```bash
MODULES=(vfio_pci vfio vfio_iommu_type1)
```

Rebuild the initramfs for **all** kernels (check yours with `uname -r`, or use `-p linux-lts` for the LTS kernel only):

```bash
sudo mkinitcpio -P
```

## 4. Reboot

```bash
reboot
```

## 5. Verify

Don't filter with `grep nvidia`, because it hides the driver line when the driver is `vfio-pci`. Query the devices directly:

```bash
lspci -nnk -d 10de:13c2
lspci -nnk -d 10de:0fbb
```

Both should show `Kernel driver in use: vfio-pci`:

```text
0b:00.0 VGA compatible controller [0300]: NVIDIA Corporation GM204 [GeForce GTX 970] [10de:13c2] (rev a1)
	Kernel driver in use: vfio-pci
	Kernel modules: nouveau, nvidia_drm, nvidia
0b:00.1 Audio device [0403]: NVIDIA Corporation GM204 High Definition Audio Controller [10de:0fbb] (rev a1)
	Kernel driver in use: vfio-pci
	Kernel modules: snd_hda_intel
```

Also check that the IOMMU is active and the GPU is in its own group:

```bash
sudo dmesg | grep -iE 'iommu|vfio'
```

## Troubleshooting

- **No `Kernel driver in use` line at all:** the initramfs wasn't rebuilt for the kernel you booted, or the ID list has a typo.
- **Still bound to `nvidia` or `nouveau`:** `vfio_pci` isn't loaded early enough. Recheck step 3.
- **`/sys/module/vfio_pci/parameters/ids` doesn't exist:** this is normal, since the parameter is write-only in sysfs.
