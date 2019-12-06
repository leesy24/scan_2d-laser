#!/bin/sh

export LD_LIBRARY_PATH=/flash

# Get saved 2D Laser IP address from def view serial
ip_s=$(def view serial | grep -A 4 '\[ 3\]' | grep 'Remote' | cut -d' ' -f10)
echo "Saved 2D Laser IP =" $ip_s > /dev/kmsg
# Get valid 2D Laser IP address
ip_s=$(echo $ip_s | grep -E -o '10\.0\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.[0-9]{1,2}($|[^0-9])')

# Check saved 2D Laser IP address is available
[ ! -z "$ip_s" ] && {
	# Check saved 2D Laser IP address is OK
	arping -f -q -c 2 -i eth0 $ip_s
	[ $? -eq 0 ] && ip_c=$ip_s
	[ ! -z "$ip_c" ] && {
		echo "Checked 2D Laser IP =" $ip_c > /dev/kmsg
		exit 0
		}
	echo "Check failed 2D Laser IP =" $ip_s > /dev/kmsg
	} || {
	echo "Saved 2D Laser IP is not valid!" > /dev/kmsg
	}

# Get my IP
ip_m=$(ip a show eth0 | grep -E -o 'inet 10\.0\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' | cut -d' ' -f2)
[ -z "$ip_m" ] && {
	echo "My IP is not valid!" > /dev/kmsg
	exit 1
	}
echo "My IP =" $ip_m > /dev/kmsg
                   
# Looping to scan 2D Laser IP address
while true; do
	echo "Scan 2D Laser IP..." > /dev/kmsg
	#ip_r=$(/flash/arp-scan -q -x -i 1u -r 1 -R -I eth0 10.0.0.0/16 --arpspa $ip_m | grep -E -o '10\.0\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.[0-9]{1,2}($|[^0-9])' | tr '\t' ' ' | cut -d' ' -f1)
	#ip_r=$(/flash/arp-scan -q -x -i 600u -r 1 -R -N -f /flash/ip_list.txt -I eth0 --arpspa $ip_m | grep -E -o '10\.0\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.[0-9]{1,2}($|[^0-9])' | tr '\t' ' ' | cut -d' ' -f1)
	#ip_r=$(/flash/arp-scan -q -x -i 1 -r 1 -R -N -f /flash/ip_list.txt -I eth0 --arpspa $ip_m | grep -E -o '10\.0\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.[0-9]{1,2}($|[^0-9])' | tr '\t' ' ' | cut -d' ' -f1)
	#ip_r=$(/flash/arp-scan -q -x -B 300K -r 1 -R -N -f /flash/ip_list.txt -I eth0 --arpspa $ip_m | grep -E -o '10\.0\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.[0-9]{1,2}($|[^0-9])' | tr '\t' ' ' | cut -d' ' -f1)
	ip_r=$(/flash/arp-scan -q -x -g -i 20u -r 5 -R -N -f /flash/ip_list.txt -I eth0 --arpspa $ip_m | grep -E -o '10\.0\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.[0-9]{1,2}($|[^0-9])' | tr '\t' ' ' | cut -d' ' -f1)
	[ ! -z "$ip_r" ] && break
	echo "Not found 2D Laser IP..." > /dev/kmsg
	sleep 1
done

echo "Found 2D Laser IP =" $ip_r > /dev/kmsg
ip_r=$(echo $ip_r | cut -d' ' -f1)

# Check scaned 2D Laser IP address is same to saved 2D Laser IP address
[ "$ip_r" = "$ip_s" ] && {
	echo "Already saved 2D Laser IP =" $ip_r > /dev/kmsg
	reboot
	exit 0
	}

# Set and Save new 2D Laser IP address via def command
echo "Set/Save 2D Laser IP =" $ip_r > /dev/kmsg
def port 3 remote $ip_r
def save
sync
reboot
exit 0
