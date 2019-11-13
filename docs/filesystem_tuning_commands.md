# Filesystem Tuning

This procedure was applied to the file system of some Linux servers (running 
Ubuntu 12.04 LTS) back in 2013 to get better database writing speed performance.

Let `/dev/sdXY` be the partition that you want to boost (usually the one that 
has the database tables).

Run:
```
tune2fs -o journal_data_writeback /dev/sdXY
tune2fs -e remount-ro /dev/sdXY
check the changes:
tune2fs -l /dev/sdXY
```

`vim fstab` (go to line that references the partition `sdXY`) and change the 4th 
column to: `defaults,noatime,data=writeback,barrier=0,errors=remount-ro`

`vim /etc/default/grub` and add: `GRUB_CMDLINE_LINUX_DEFAULT="elevator=deadline 
(quiet) (splash)"`  
Put the (quiet) and (splash) options only if they existed before.

Run:
`update-grub`

Check that `/boot/grub/grub.cfg` that has "elevator" somewhere:  
`cat /boot/grub/grub.cfg | grep elevator`

**REBOOT**

Afterwards check: the fstab options, the tune2fs options, and the I/O scheduler 
using:   
`cat /sys/block/sdX/queue/scheduler`
