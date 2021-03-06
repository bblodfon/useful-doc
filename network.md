# Network commands

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

## Manual NTP

First, run: `service ntp stop`  
`vim /etc/ntp.conf`

Add line: `server <host>`  
Then execute:  
`sudo ntpdate <host>`  
Check connectivity with the server on udp ntp port 123 with:
`nc -u <host> <port>`  
`service ntp start`

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

## Capture LTE and 2G3G traffic
  
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

## Useful network-capturing commands

- Changing the content of `.pcap` files  
`tcprewrite --enet-vlan=add --enet-vlan-tag=110 --enet-vlan-cfi=1 
--enet-vlan-pri=4 --infile=GTPv1_noVLAN.pcap --outfile=GTPv1_withVLAN110.pcap`

- Use of `tcpreplay`  
`tcpreplay -i eth2 -K -l0 --topspeed replayfiles/file.pcap`

- See the VLAN ids of the captured packets  
`tshark -i any -Tfields -e vlan.id`
