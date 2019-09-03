#!/bin/bash

# Add USBKill as systemd service v0.2
# Tested with CentOS 7, Fedora 29-30
#
#  You need the original USBKill from hephaestos (https://github.com/hephaest0s/usbkill) and copy this script to the root of usbkill dir, such as:
#  # git clone git@github.com:hephaest0s/usbkill.git /opt/usbkill
#  # cp usbkill-service.sh /opt/usbkill/
#  # cd /opt/usbkill/
#  # ./usbkill-service.sh

if [ "$EUID" -ne 0 ] ; then
	printf "Must be run as root\n"
	exit
else

DATE=`date +%F_%S`

case "$1" in
	add) 
		if [ ! -f /usr/lib/systemd/system/usbkill.service ] ; then
			printf "[Unit]\nDescription=USBKill\n\n[Service]\nType=simple\nExecStart=/bin/python /opt/usbkill/usbkill/usbkill.py\n\n[Install]\nWantedBy=multi-user.target\n" > /usr/lib/systemd/system/usbkill.service ;
			chmod 644 /usr/lib/systemd/system/usbkill.service ;
			systemctl daemon-reload ;
			printf "OK: Systemd file /usr/lib/systemd/system/usbkill.service created.\n"
		else
			printf "WARNING: Systemd file /usr/lib/systemd/system/usbkill.service already found, skipping.\n"
		fi

		if [ ! -f /etc/usbkill.ini ] ; then
			cp ./install/usbkill.ini /etc/usbkill.ini ;
			chmod 600 /etc/usbkill.ini ;
			printf "OK: Configuration file copied from ./install/usbkill.ini -> /etc/usbkill.ini.\n"
		else
			printf "WARNING: Configuration file /etc/usbkill.ini already found, skipping.\n"
		fi

		printf "\nYou can now use USBKill as service by running:\n# systemctl {start|stop|status|enable|disable} usbkill.service\n"
	;;

	remove)
		if [ ! -f /usr/lib/systemd/system/usbkill.service ] ; then
			printf "Systemd file /usr/lib/systemd/system/usbkill.service already removed, skipping.\n"
		else
			cp /usr/lib/systemd/system/usbkill.service /tmp/usbkill.service_$DATE.bak ;
			rm -f /usr/lib/systemd/system/usbkill.service ;
			systemctl daemon-reload ;
			printf "OK: Systemd file /usr/lib/systemd/system/usbkill.service removed and backup copied to /tmp/usbkill.service_$DATE.bak.\n"
		fi

		if [ ! -f /etc/usbkill.ini ] ; then
			printf "Configuration file /etc/usbkill.ini already removed, skipping.\n"
		else
			cp /etc/usbkill.ini /tmp/usbkill.ini_$DATE.bak ;
			rm -f /etc/usbkill.ini ;
			printf "OK: Configuration file /etc/usbkill.ini removed and backup copied to /tmp/usbkill.ini_$DATE.bak.\n"
		fi
	;;

	check)
		if [ ! -f /usr/lib/systemd/system/usbkill.service ] ; then
			printf "ERROR: Systemd file /usr/lib/systemd/system/usbkill.service not found.\n"
		else
			printf "OK: Systemd file /usr/lib/systemd/system/usbkill.service found.\n"
		fi

		if [ ! -f /etc/usbkill.ini ] ; then
			printf "ERROR: Configuration file /etc/usbkill.ini not found.\n"
		else
			printf "OK: Configuration file /etc/usbkill.ini found.\n"
		fi
	;;
	
	*)
		printf $"Usage: $0 {add|remove|check}\n"
	;;
esac

fi
