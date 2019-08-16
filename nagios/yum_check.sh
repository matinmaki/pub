#!/bin/bash

# Yum update check for Nagios Remote Plugin Executor (NRPE) v0.2
# Tested with CentOS 7, RHEL 7
#
#  Nagios exit codes:
#  0 = OK
#  1 = WARNING
#  2 = CRITICAL
#  3 = UNKNOWN
#

if [ -f /usr/bin/yum ]; then
        OUTPUT=$(/usr/bin/yum -C --security check-update | grep "needed for security")
        if echo $OUTPUT | grep -q "No packages"; then
        echo "OK: $OUTPUT"
        exit 0
        else
                echo "WARNING: $OUTPUT"
                exit 1
        fi
else
echo "Error: /usr/bin/yum not found"
exit 3
fi
