#!/bin/bash
# --- T2-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
# 
# T2 SDE: package/.../rocknet/ifswitch.sh
# Copyright (C) 2006 The T2 SDE Project
# 
# More information can be found in the files COPYING and README.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- T2-COPYRIGHT-NOTE-END ---

set -e

active=$( cat /var/run/rocknet/active-interfaces 2>/dev/null || true )

if [ $# -eq 0 ]; then
	echo "Usage $0 [ interface profile ] | [ profile ]"
	exit
fi

i=0
for x in ${active//,/ }; do
	[ $(( i++ )) -eq 0 ] && echo "Deactivating current interfaces ..."
	if=${x/(*)/}
	profile=${x/*(/}; profile=${profile%)}
	ifdown $if $profile
done

echo "Activating specified profile/interfaces ..."

if [ $# -eq 1 ]; then
	rocknet $1 auto up
else
	ifup $1 $2
fi
