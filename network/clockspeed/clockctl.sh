#!/bin/sh
# --- SDE-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
#
# Filename: package/.../clockspeed/clockctl.sh
# Copyright (C) 2008 - 2012 The OpenSDE Project
#
# More information can be found in the files COPYING and README.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- SDE-COPYRIGHT-NOTE-END ---

# Based on: http://www.thedjbway.org/clockspeed/clockctl
# interface to djb clockspeed (0.62)
# wcm, 2003.11.26 - 2003.11.26
# ===

die() {
	echo "$0: $*" >&2
	exit 1
}

# read configuration:
if [ -r /etc/conf/clockspeed ] ; then
	. /etc/conf/clockspeed
else
	die "configuration error: unable to read /etc/conf/clockspeed"
fi

# clock_pick function:
clock_pick() {
	case "${CLOCK_TYPE}" in
		ntp|NTP)	D_bindir/sntpclock "${CLOCK_IP}"
			;;
		tai|TAI)	D_bindir/taiclock "${CLOCK_IP}"
			;;
		*)
			die "configuration error: CLOCK_TYPE not recognized"
			;;
	esac
}


# process command:
case "$1" in
	a|atto)
		echo "Viewing current attoseconds in hardware tick:"
		D_bindir/clockview < /var/state/clockspeed/atto
		;;
	m|mark)
		[ -p /var/state/clockspeed/adjust ] ||
			die "Cannot obtain new calibration mark (clockspeed running?)"
		echo "Obtaining new calibration mark from master server at ${CLOCK_IP}:"
		clock_pick | tee /var/state/clockspeed/adjust | D_bindir/clockview
		;;
	s|sync)
		echo "Setting system clock with master server at ${CLOCK_IP}:"
		clock_pick | D_bindir/clockadd && \
		clock_pick | D_bindir/clockview
		;;
	v|view)
		echo "Checking system clock against master server at ${CLOCK_IP} (clockview):"
		clock_pick | D_bindir/clockview
		;;
	h|help)
		cat <<-EOT
		clockspeed control:
		  atto -- inspect current "attoseconds"
		  mark -- obtain new calibration mark for clockspeed
		  sync -- set the system clock with master time server
		  view -- check system clock against master time server
		  help -- this screen
		EOT
		exit 0
		;;
	*)
		echo "Usage: $0 [ a|atto | m|mark | s|sync | v|view | h|help ]"
		exit 1
		;;
esac

### that's all, folks!
