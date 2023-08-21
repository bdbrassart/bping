# bping
Simple visual ping monitor utility to watch multiple hosts simultaneously.  I found myself frustrated watching multiple ping commands while doing maintenance or waiting for a device to come back up after reboot.

## To install:

Developed under Ubuntu Linux.  No idea if there are compatibility issues with other distributions.  Uses fping under the hood.

```
sudo apt install fping
chmod +x bping.sh
sudo cp bping.sh /usr/bin/bping
```

## Usage:

This utility was created to monitor multiple hosts and provide an easy visual reference to their current status.

```bping <options> <argument>```

```bping -h <hostname/IP>```
  Ping a single hostname or IP address.
  
```bping -f <filename.txt>```
  Ping all hostnames/IP addresses in a text file.
  
```bping --help```
  Display the help file.

```bping <hostname/IP>```
  Same as -h.
  
  
