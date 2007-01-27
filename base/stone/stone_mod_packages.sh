# --- T2-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
# 
# T2 SDE: package/.../stone/stone_mod_packages.sh
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
#
# [MAIN] 90 packages Package Management (Install, Update and Remove)

if [ -n "$ROCK_INSTALL_SOURCE_DEV" ] ; then
	dev="$ROCK_INSTALL_SOURCE_DEV"
	dir="/mnt/source" ; root="/mnt/target"
	gasguiopt="-F"

	SDECFG_SHORTID="Automatically choose first"
elif [ -n "$ROCK_INSTALL_SOURCE_URL" ] ; then
	dev="NETWORK INSTALL"
	dir="$ROCK_INSTALL_SOURCE_URL" ; root="/mnt/target"
	gasguiopt="-F"

	SDECFG_SHORTID="$( grep '^export SDECFG_SHORTID=' \
		/etc/SDE-CONFIG/config 2> /dev/null | cut -f2- -d= )"
	SDECFG_SHORTID="${SDECFG_SHORTID//\'/}"
else
	dev="/dev/cdrom"
	dir="/mnt/cdrom" ; root="/"
	gasguiopt=""

	SDECFG_SHORTID="$( grep '^export SDECFG_SHORTID=' \
		/etc/SDE-CONFIG/config 2> /dev/null | cut -f2- -d= )"
	SDECFG_SHORTID="${SDECFG_SHORTID//\'/}"
fi

read_ids() {
	mnt="`mktemp`"
	rm -f $mnt ; mkdir $mnt

	cmd="$cmd '' ''"

	if mount $opt $dev $mnt ; then
		for x in `cd $mnt; ls -d */{,TOOLCHAIN/}pkgs 2> /dev/null | sed -e 's,/pkgs$,,'`
		do
			cmd="$cmd '$x' 'SDECFG_SHORTID=\"$x\"'"
		done
		umount $mnt
	else
		cmd="$cmd 'The medium could not be mounted!' ''"
	fi

	rmdir $mnt
}

startgas() {
	[ -z "$( cd $dir; ls )" ] && mount $opt -v -o ro $dev $dir
	if [ "$SDECFG_SHORTID" = "Automatically choose first" ]; then
		SDECFG_SHORTID="$( cd $dir; ls -d */{,TOOLCHAIN/}pkgs 2> /dev/null | \
					sed -e 's,/pkgs$,,' | head -n 1 )"
		echo "Using Config-ID <${SDECFG_SHORTID:-None}> .."
	fi
	if [ $startgas = 1 ] ; then
		echo
		echo "Running: gasgui $gasguiopt \\"
		echo "                -c '$SDECFG_SHORTID' \\"
		echo "                -t '$root' \\"
		echo "                -d '$dev' \\"
		echo "                -s '$dir'"
		echo
		gasgui $gasguiopt -c "$SDECFG_SHORTID" -t "$root" -d "$dev" -s "$dir"
	elif [ $startgas = 2 ] ; then
		echo
		echo "Running: stone gas main \\"
		echo "               '$SDECFG_SHORTID' \\"
		echo "               '$root' \\"
		echo "               '$dev' \\"
		echo "               '$dir'"
		$STONE gas main "$SDECFG_SHORTID" "$root" "$dev" "$dir"
	fi
}

main() {
	local startgas=0
	while : ; do
		cmd="gui_menu packages 'Package Management

Note: You can install, update and remove packages (as well as query
package information) with the command-line tool \"mine\". This is just
a simple frontend for the \"mine\" program.'"

		cmd="$cmd 'Mount Options:  $opt'"
		cmd="$cmd 'gui_input \"Mount Options (e.g. -s -o sync) \" \"\$opt\" opt'"

		cmd="$cmd 'Source Device:  $dev'"
		cmd="$cmd 'gui_input \"Source Device\" \"\$dev\" dev'"

		cmd="$cmd 'Mountpoint:     $dir'"
		cmd="$cmd 'gui_input \"Mountpoint\" \"\$dir\" dir'"

		cmd="$cmd 'Config ID: $SDECFG_SHORTID'"
		cmd="$cmd 'gui_input \"Config ID\""
		cmd="$cmd \"\$SDECFG_SHORTID\" SDECFG_SHORTID'"

		read_ids

		cmd="$cmd '' ''"
		type -p gasgui > /dev/null &&
			cmd="$cmd 'Start gasgui Package Manager (recommended)' 'startgas=1'"
		cmd="$cmd 'Start gastone Package manager (minimal)'  'startgas=2'"

		if eval "$cmd" ; then
			if [ $startgas != 0 ]; then
				startgas $startgas
				break
			fi
		else
			break
		fi
	done
}

