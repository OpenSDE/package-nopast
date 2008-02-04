#!/bin/sh
#
# --- T2-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
#
# T2 SDE: package/.../cron/cron.run.sh
# Copyright (C) 2004 - 2006 The T2 SDE Project
# Copyright (C) 1998 - 2003 Clifford Wolf
#
# More information can be found in the files COPYING and README.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- T2-COPYRIGHT-NOTE-END ---

if [ "$1" = "-mail-to-root" ] ; then
	$0 2>&1 | mail -s "Cron at `hostname` [`date +%Y-%m-%d`]" root
	exit
fi

x="$( hostname -f 2> /dev/null )"
echo "Output of the daily cron at ${x:-localhost}."
echo "Local time is `date | tr -s ' '`."
echo

cd /

for x in /etc/cron.daily/*
do
	echo "-- $x"
	echo
	$x
done

