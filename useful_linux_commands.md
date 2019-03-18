# Useful Linux commands

## ssh linux server without password

Usually you do: `ssh username@IP` and enter a password. We want to do just 
`ssh IP` or `ssh name.com` (name.com translates to the global IP).

```
cd ~/.ssh
# create public and private key
ssh-keygen -o
# your public key
cat id_rsa.pub
# copy it to the server
cat id_rsa.pub | ssh username@IP 'cat >> .ssh/authorized_keys'
```

## Do something on many files in a dir

*Something* can be: rendering notebooks to HTML or checking if the files are 
the same as other files for example
```bash
#!/bin/bash

files=`ls`
dir="/somewhere/over/the/rainbow"
rmd_files=`ls | grep Rmd`

for file in ${files}; do
  diff -s $dir$file $file
  Rscript -e "library(rmarkdown); rmarkdown::render(\"./$file\",\"html_document\")"
done
```

## Save many directories in one tar.gz file
```bash
#!/bin/bash

saveDir="~/pathToSaveDir"
dir="~/pathToDirThatHasManyOtherDirs"

# names of dirs you want to save
dir1=$dir"dir1"
dir2=$dir"dir2"
dir3=$dir"dir3"

tarFileToSave=$saveDir"name.tar.gz"

tarCommand="tar -zcvf ${tarFileToSave} ${dir1} ${dir2} ${dir3} >/dev/null 2>&1"
eval $tarCommand

echo "Runned command:"
echo $tarCommand

checkModificationTimeCommand="stat ${tarFileToSave}"
eval $checkModificationTimeCommand
```

## Make desktop icons appear and disappear
```
gsettings set org.gnome.desktop.background show-desktop-icons false
```

## Find the sum in MB of files in a directory
`ls | xargs stat --format=%s | awk '{s+=$1} END {print s/(1024*1024)}'`

## Count lines of source code
`find . -name '*.php' | xargs wc -l`  
or use cloc: `apt-get install cloc`

## MySQL: Size of a MyISAM table in GB
`ls /var/lib/mysql/database/tableName.* | xargs stat --format=%s | awk '{s+=$1} 
END {print s/(1024*1024*1024)}'`

## MySQL: Drop many tables matching a pattern
`SELECT CONCAT( 'DROP TABLE ', GROUP_CONCAT(table_name) , ';' ) AS statement 
FROM information_schema.tables WHERE table_name LIKE 'patternToMatch%';`

## MySQL: Count rows and size of MyISAM tables that have the date in their name
```bash
#!/bin/bash
  
date=`date -d 'Oct 13 14:00:00 2020' +%s` ;
end_date=`date -d 'Nov 27 00:00:00 2020' +%s`;

while [ $date -lt $end_date ];
  do date -d @$date +%Y%m%d;
  date=$(expr $date + 86400) ;
  done |

while read x ;
do
        echo quering count: $x
        table=tableSuffix$x
        rows=`mysql -u username -p password -e "select count(*) from $table\G"|tail -n 1|awk '{print $2}'`
        size=`du -ch /var/lib/mysql/databaseName/$table* | tail -n1 | awk '{print $1}' | sed 's/G//'`
        echo $x,$rows,$size >> output.txt
done
```

## Delete files efficiently
```
find . -maxdepth 1 -name "something*" -print0 | xargs -0 rm
```

## Count and change the reserved space in an ext4 partition 'ONLINE'

Change the reserved space to 1%: `tune2fs -m 1 /dev/sdb1`  
Count the percentage:  
```
a=$(tune2fs -l /dev/sdb1 | grep -i 'Reserved block count' | awk '{ print $4 }')
b=$(tune2fs -l /dev/sdb1 | grep 'Block count' | awk  '{ print $3 }')
echo "scale=5; ($a/$b)*100" | bc # this is the precentage of the reserved space
```

## Kill many processes at once (that much a pattern)
```
ps aux | grep -v grep | grep -i patternToMatch | awk '{print $2}' | xargs kill -9
```

## Problem: After deleting many files, the space is not freed and you need to delete the file descriptors
`find /proc/*/fd -ls 2> /dev/null | awk '/deleted/ {print $11}' | xargs -p -n 1 truncate -s 0`

## Add permanent bash alias

`vim ~/.bashrc` or `vim ~/.bash_aliases`  
and add a line like this:  
`alias fifa='ifconfig | grep ask`  
Then save the file and run:  
`. ~/.bash_aliases` or `. ~/.bashrc`

- So, to change directory coloring for example run:  
`echo "LS_COLORS=$LS_COLORS:'di=0;36:' ; export LS_COLORS" >> ~/.bash_aliases`

- Best values:
    - Cyan = 36
    - light purple = 95

- Table of color values:

Color|Value
:---:|:---:
Blue | 34
Green | 32
Light Green | 1;32
Cyan | 36
Red | 31
Purple | 35
Brown | 33
Yellow | 1;33
white | 1;37
Light Grey | 0;37
Black | 30
Dark Grey | 1;30
The first number is the style (1=bold), followed by a semicolon, and then the 
actual number of the color

## Find number of CPUs and model
```
grep -c processor /proc/cpuinfo
lscpu
nproc
cat /proc/cpuinfo | grep name | tail -n1
```

## Allow only sftp access of a user to a specific folder

Check [here](http://passingcuriosity.com/2014/openssh-restrict-to-sftp-chroot/)
```
addgroup exchangefiles
mkdir /home/exchangefiles/ (create also any subsequent folders)
chgrp -R exchangefiles /home/exchangefiles/
vim /etc/ssh/sshd_config 
```
Add in the end of the file:
```
Match Group exchangefiles
  # Force the connection to use SFTP and chroot to the required directory.
  ForceCommand internal-sftp
  ChrootDirectory /home/exchangefiles
  # Disable tunneling, authentication agent, TCP and X11 forwarding.
  PermitTunnel no
  AllowAgentForwarding no
  AllowTcpForwarding no
  X11Forwarding no
```
```
adduser --ingroup exchangefiles testfiles
service ssh restart
```
check:
```
sftp testfiles@serverIP (OK)
ssh testfiles@serverIP (REFUSED)
```
also `mount --bind /dir1 /dir2` is very usefull too

## Dynamic linking

`ldd <executable_name>`  
if you see *not found* for some library, put the <something>.so.x.x.x file in: 
`/usr/local/lib`  
`ln -s <something>.so.x.x.x <something>.so.x` (or whatever is needed)
and do: `ldconfig -v`  
Then: `ldd <executable_name>` should be OK

## Manual NTP

First, run: `service ntp stop`  
`vim /etc/ntp.conf`

Add line: `server <host>`  
Then execute:  
`sudo ntpdate <host>`  
Check connectivity with the server on udp ntp port 123 with:
`nc -u <host> <port>`  
`service ntp start`

## Change hostname

Stop MySQL if it is running: `service mysql stop`
```
old hostname = <old>
new hostname = <new>
```
In the next 2 files change `<old>` to `<new>`:
```
vim /etc/hosts
vim /etc/hostname
```
and run:
`hostname <new>`
Then check:
`hostname`

Restart MySQL (if needed): `service mysql start`

## Service tag
`dmidecode -t system`

## Add 80-character colomn bar in vim
```bash
vim /etc/vim/vimrc

# add line
set colorcolumn=80
```

## Change vim comment color
Go to `/usr/share/vim/vim80/colors` and copy a file with a nice color scheme:
`cp ron.vim zobo.vim`  
Then: `vim zobo.vim` and change lines:  
`let g:colors_name = "zobo"`  
`hi comment ctermfg=green guifg=green`  
Then:
`vim /etc/vim/vimrc`  
Add line somewhere: `color zobo`

## See cached files info in the pwd
`linux-fincore --pages=false --summarize --only-cached *`

## Clean cached memory (extremely useful :)
`sync && echo 3 | tee /proc/sys/vm/drop_caches`

## Build a specific filesystem on a disk partition 
```
cat /etc/fstab
fdisk -l
cfdisk /dev/sdc
mkfs.ext4 /dev/sdc1 
mount -a
df -h
```

## DNS problem

Reproduce the problem:
- change/add the dns-nameservers x.x.x.x in `/etc/network/interfaces`
- `service networking restart` **DOES NOT WORK**, which means that:
- `vim /etc/resolv.conf` doesn't have the new address: `nameserver x.x.x.x`


If the setup was something like this:
```
iface IIII FFFF static
    address ...
    ...
    dns-nameservers X.X.X.X Y.Y.Y.Y
    dns-search SSSS
```
then do (the spaces are needed): 
```
echo "nameserver X.X.X.X
nameserver Y.Y.Y.Y
search SSSS" | sudo resolvconf -a IIII.FFFF
```
check the `/etc/resolv.conf`, the changes should have been applied there.

## Force a Gateway in a route table
`vim /etc/network/interfaces` and add:  
`up route add -net 204.16.0.0 netmask 255.255.0.0 (gw 62.133.78.129) dev eth12`

Using the terminal:
```
route add -net 3.3.3.0 netmask 255.255.255.0 dev eth13
/etc/init.d/networking restart; ifup eth10
``` 
(whichever ethX has the ip you have sshed' to get to the machine)

## Get the FIBRE ports
`lspci -v | grep 10-G -A8`

## Check all IPs in the local network (extremely useful :)
`nmap -sP 192.168.1.*`

## Create a network bridge between two interfaces
```
apt-get install bridge-utils

brctl addbr br0
brctl stp br0 on
ifconfig eth0 0.0.0.0 down
ifconfig eth1 0.0.0.0 down
brctl addif br0 eth0
brctl addif br0 eth1

ifconfig eth0 up
ifconfig eth1 up
ifconfig br0 up
```
For the bridge to have an IP also, run:
`ifconfig br0 192.168.1.173`  
To remove this IP: `ifconfig br0 0.0.0.0`

## Checking Firewall Rules (from A to B):

**A (IPA, PortA) -----> B (IPB, PortB)**

- Testing ssh (port 22): `ssh IPB`
- Testing port 3306 (mysql-related): `telnet IPB 3306`
- From all ports of **A** to a specific port on **B**: 
	- **B**: `nc -l PortB`
	- **A**: `nc -u IPB PortB` (-u tests udp, without it you test TCP connectivity) 
	and write stuff there, you should see them on **B**... or you can do a trace 
	on **B** to make sure you got the packets: `tshark -i any udp port portB`
- From a specific port of **A** to a specific port on **B**:
	- **B**: `nc -l portB`
	- **A**: `nc -u IPB PortB -p PortA` (you should see them on **B**... or you 
	can do a trace on **B** to make sure you got the packets: `tshark -i any udp 
	port portB`)
- From a specific port of **A** to a specific port on **B**:
	- **B**: `nc -l portB`
	- **A**: `nc -u IPB PortB -p PortA`

# Capture LTE and 2G3G traffic
  
- LTE traffic (with VLAN)  
`tcpdump -i any "ether[27]==0 and ((ether[49] < 0x26 and ether[49] > 0x1F) or 
(ether[49] < 0x65 and ether[49] > 0x62) or (ether[49] > 0xa9 and ether[49] < 
0xac))" -w out.pcap`

- LTE traffic (no VLAN)  
`tcpdump -i any "ether[23]==0 and ((ether[45] < 0x26 and ether[45] > 0x1F) or 
(ether[45] < 0x65 and ether[45] > 0x62) or (ether[45] > 0xa9 and ether[45] < 
0xac))" -w out.pcap`

- 2G3G traffic (with VLAN)  
`tshark -i any "ether[49] < 0x16 and ether[27]==0 and ether[49] > 0x0e" -w out.pcap`

- 2G3G traffic (no VLAN)  
`tshark -i any "ether[45] < 0x16 and ether[23]==0 and ether[45] > 0x0e" -w out.pcap`

# Useful network-capturing commands

- Changing the content of `.pcap` files  
`tcprewrite --enet-vlan=add --enet-vlan-tag=110 --enet-vlan-cfi=1 
--enet-vlan-pri=4 --infile=GTPv1_noVLAN.pcap --outfile=GTPv1_withVLAN110.pcap`

- Use of `tcpreplay`  
`tcpreplay -i eth2 -K -l0 --topspeed replayfiles/file.pcap`

- See the VLAN ids of the captured packets  
`tshark -i any -Tfields -e vlan.id`
