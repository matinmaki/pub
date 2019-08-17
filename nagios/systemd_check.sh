#!/bin/bash

# Systemd check for Nagios Remote Plugin Executor (NRPE) v0.1
# Tested with CentOS 7, RHEL 7-8
#
#  Nagios exit codes:
#  0 = OK
#  1 = WARNING
#  2 = CRITICAL
#  3 = UNKNOWN
#

if [ -f /bin/systemctl ] ; then
        OUTPUT=$(/bin/systemctl --failed --no-legend | awk '!($2=$3=$4="")')
        if [ "$OUTPUT" != "" ]; then
                printf "CRITICAL: Failed unit(s): "$OUTPUT" \n"
                exit 2
        else
                printf "OK: No failed units"
                exit 0
        fi
else
        printf "Error: No /bin/systemctl found"
        exit 3
fi
