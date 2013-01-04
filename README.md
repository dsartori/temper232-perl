# temper232-perl

A collection of scripts for working with the Temper232 temperature monitor.

## Install

t232.pl can be placed anywhere in the file system on a Linux system. Modify the $port variable to point to the correct virtual serial port device for your Temper232 sensor.

## Mon 
temper.monitor is intended for use with Jim Trocki's "Mon" https://mon.wiki.kernel.org/index.php/Main_Page. On a Debian system, place this file into the folder /usr/lib/mon/mon.d and modify its permission settings so that it is executable by Mon:

```
chmod a+x /usr/lib/mon/mon.d/temper.monitor
```

To use this monitor, create a "temp" hostgroup in /etc/mon.cf pointing to the serial device corresponding to the Temper232.  In most cases this will be /dev/ttyUSB0:


```
#
# Define groups of hosts to monitor
#
hostgroup localhost localhost 

hostgroup temp /dev/ttyUSB0
```

Also in mon.cf, define the monitoring specification.  Here is an example:

```
watch temp
  service temperature
    description Temp monitor
    interval 1m
    monitor temper.monitor -t 10 -l 10 -h 25
    period
      numalerts 10
      alert mail.alert bob@aol.com
```
