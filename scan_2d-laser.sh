#!/bin/sh

ip_s=$(def view serial | grep -A 4 '\[ 3\]' | grep 'Remote' | cut -d' ' -f10)
#ip_s="10.0.24.6"
echo "Saved IP =" $ip_s

ip_c=$(/flash/arp-scan -q -i 1u -r 1 -I eth0 $ip_s | grep -o $ip_s)
[ ! -z "$ip_c" ] && {
	echo "Checked IP =" $ip_c
	exit 0
	}
echo "Check failed IP =" $ip_s

echo "Scan IP..."
#./arp-scan -q -i 1u -r 1 -I eth0 10.0.0.0/16 | grep -Eo '10.0.*' | tr '\t' ' ' | cut -d' ' -f1
#./arp-scan -q -i 1u -r 1 -I eth0 10.0.0.0/16 | grep -Eo '10.0.*.*' | cut -d'	' -f1
#./arp-scan -q -i 1u -r 1 -I eth0 10.0.0.0/16 | grep -E -o '10\.0\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' | cut -d'	' -f1
#./arp-scan -q -i 1u -r 1 -I eth0 $ip_s | grep -o $ip_s
ip_r=$(/flash/arp-scan -q -i 1u -r 1 -I eth0 10.0.0.0/16 | grep -E -o '10\.0\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.[0-9]{1,2}($|[^0-9])' | tr '\t' ' ' | cut -d' ' -f1)
[ -z "$ip_r" ] && {
	echo "Not found IP..."
	exit 1
	}

echo "Found IP =" $ip_r
ip_r=$(echo $ip_r | cut -d' ' -f1)
def port 3 remote $ip_r
def save
exit 0



