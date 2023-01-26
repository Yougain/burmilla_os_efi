## rancher_os_efi
# create_rancheros_efi_iso
  A script for creating an iso image of RancherOS installer with EFI.<br>
  ```
  $ ./create_rancheros_efi_iso
  　...... # Downloading RancherOS and Ubuntu iso images.
  　...... # Copy files with EFI function from Ubuntu iso image to a new RancherOS iso image.
  　# You get ~/rancheros_efi/rancheros-v1.x.x.efi.iso finally.
  $ ls ~/rancheros_efi
  rancheros-v1.5.8.efi.iso  rancheros-v1.5.8.iso  ubuntu-22.04.1-live-server-amd64.iso
  ```
# install_rancheros_on_raid_lvm
　A scpipt for installing RancherOS on a lvm/raid partition in a hard disk of a baremetal server.<br>
　After booting up by rancheros-v1.x.x.efi.iso, set password for user, 'rancher' with 'rancher' (same as user name) as follows.
 ```
 Autologin default
 [rancher@rancher ~]$ sudo passwd rancher
 Changing passwd for rancher
 New password: (typing 'rancher')
 Bad passwrod: similar to username
 Retype password: (typing 'rancher')
 passwd: password for rancher changed by root
 ```
 Chek the IP address (xxx.xxx.xxx.xxx) of the new server.
 ```
 [rancher@rancher ~]$ ip addr show dev eth0 | grep inet
 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    inet xxx.xxx.xxx.xxx/24 brd xxx.xxx.xxx.255 scope global eth0
 ```
 Execute the script from your terminal. The script uses default server name, 'rancher'.
 ```
 $ ./install_rancheros_on_raid_lvm xxx.xxx.xxx.xxx
   ...... # your ssh public key will be registered.
   ...... # LVM Patition, /dev/vg0/lv0 will be created on raid device /dev/md127 on /dev/sda5
   ...... # reboot
 ```
 Reboot from the hard disk of the server.<br>
 Login from yout terminal and check the disk status.<br>
 ```
 $ ssh -l rancher xxx.xxx.xxx.xxx
 
[rancher@rancher ~]$ fdisk -l /dev/sda
Disk /dev/sda: ----.--- TiB, -------- bytes, ------- sectors
Disk model: --------
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: ---------------------

Device          Start         End     Sectors  Size Type
/dev/sda1          34        2047        2014 1007K BIOS boot
/dev/sda2        2048      526335      524288  256M EFI System
/dev/sda3      526336   134744063   134217728   64G Linux swap
/dev/sda4   134744064   138938367     4194304    2G Linux RAID
/dev/sda5   138938368  2823292927  2684354560  1.3T Linux RAID
/dev/sda6  ---------- ----------- ----------- ----T Linux RAID

[rancher@rancher ~]$ df -h
Filesystem           Size  Used Avail Use% Mounted on
overlay              959G  2.3G  906G   1% /
devtmpfs             1.9G     0  1.9G   0% /dev
tmpfs                1.9G     0  1.9G   0% /sys/fs/cgroup
/dev/mapper/vg0-lv0  959G  2.3G  906G   1% /mnt
none                 1.9G  864K  1.9G   1% /run
shm                   64M     0   64M   0% /dev/shm
/dev/md125           2.0G  134M  1.7G   8% /boot
/dev/sda2            253M  3.2M  249M   2% /boot/efi

```

# rancher_console_up_to_almalinux9
A script for upgrading Centos console to AlmaLinux 9<br>
Simply execute from terminal used at installation before.
```
$ ./rancher_console_up_to_almalinux9 xxx.xxx.xxx.xxx
.........# swithing console to centos
.........# upgrading CentOS7 to CentOS8
.........# upgrading CentOS8 to AlmaLinux8
.........# upgrading AlmaLinux8 to AlmaLinux9
.........# reboot
```
Login from yout terminal and check the release.<br>
```
$ ssh -l rancher xxx.xxx.xxx.xxx

[rancher@rancher ~]$ cat /etc/almalinux-release
AlmaLinux release 9.1 (Lime Lynx)
```
　
