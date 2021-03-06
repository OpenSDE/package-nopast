#!/bin/sh
# --- SDE-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
#
# Filename: package/.../udev/read_nodes.sh
# Copyright (C) 2008 The OpenSDE Project
#
# More information can be found in the files COPYING and README.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- SDE-COPYRIGHT-NOTE-END ---

nodes_read() {
	local prefix="$1" dir="$2" node= nodename= mode= type= data=
	for nodename in $( cd "$dir"; ls -1d * 2> /dev/null ); do
		node="$dir/$nodename"
		mode=$( stat -c '%a %U %G' "$node" )
		label="$prefix$nodename"
		type='?'
		data=
		
		if [ -L "$node" ]; then
			type='l'
			data=$( readlink "$node" )
		elif [ -d "$node" ]; then
			type='d'
		elif [ -c "$node" ]; then
			type='c'
			data=$( stat -c '%t %T' "$node" )
		elif [ -S "$node" ]; then
			type='s'
		fi

		echo "$type $label $mode${data:+ $data}"
		[ "$type" != d ] || nodes_read "$label/" "$node"
	done
}

for dir; do
	nodes_read "" "${dir%/}"
done
