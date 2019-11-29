#!/bin/sh

export LD_LIBRARY_PATH=/flash

# Get saved IP address from def view serial
ip_s=$(def view serial | grep -A 4 '\[ 3\]' | grep 'Remote' | cut -d' ' -f10)
echo "Saved 2D Laser IP =" $ip_s

# Check saved IP address is available
[ ! -z "$ip_s" ] && {
	# Check saved IP address is OK
	arping -f -q -c 2 -i eth0 $ip_s
	[ $? -eq 0 ] && ip_c=$ip_s
	#ip_c=$(/flash/arp-scan -q -i 1u -r 1 -I eth0 $ip_s | grep -o $ip_s)
	[ ! -z "$ip_c" ] && {
		echo "Checked 2D Laser IP =" $ip_c
		exit 0
		}
	echo "Check failed 2D Laser IP =" $ip_s
	}

# Looping to scan IP address
while true; do
	echo "Scan IP..."
	ip_r=$(/flash/arp-scan -q -i 1u -r 1 -I eth0 10.0.0.0/16 | grep -E -o '10\.0\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.[0-9]{1,2}($|[^0-9])' | tr '\t' ' ' | cut -d' ' -f1)
	[ ! -z "$ip_r" ] && break
	echo "Not found 2D Laser IP..."
	sleep 1
done

echo "Found 2D Laser IP =" $ip_r
ip_r=$(echo $ip_r | cut -d' ' -f1)

# Check scaned IP address is same to saved IP address
[ "$ip_r" = "$ip_s" ] && {
	echo "Already saved 2D Laser IP =" $ip_r
	#reboot
	exit 0
	}

# Set and Save new IP address via def command
echo "Set/Save 2D Laser IP =" $ip_r
def port 3 remote $ip_r
def save
sync
reboot
exit 0



