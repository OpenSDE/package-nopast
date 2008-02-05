# --- SDE-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
#
# Filename: package/.../dhcpcd/rocknet_dhcpcd.sh
# Copyright (C) 2004 - 2006 The T2 SDE Project
#
# More information can be found in the files COPYING and README.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- SDE-COPYRIGHT-NOTE-END ---

public_dhcpcd() {
	local pidfile=/etc/dhcpc/dhcpcd-$if.pid
	if [ -f $pidfile ]; then
		addcode up   5 4 "[ -f $pidfile -a ! -d /proc/\$( cat $pidfile ) ] && rm -f $pidfile"
		addcode down 5 4 "rm -f $pidfile"
	fi
	addcode up   5 5 "/usr/sbin/dhcpcd -h $( hostname ) -d -D $if"
	addcode down 5 5 "[ -f $pidfile ] && kill -15 \$( cat $pidfile )"
}

