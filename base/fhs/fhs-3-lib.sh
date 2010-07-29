# --- SDE-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
#
# Filename: package/.../fhs/fhs-3-lib.sh
# Copyright (C) 2006 - 2010 The OpenSDE Project
#
# More information can be found in the files COPYING and README.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- SDE-COPYRIGHT-NOTE-END ---

lib=

case $arch_machine in
	powerpc64|sparc64|x86_64|mips64)
		lib=lib64 ;;
esac

for x in '' 'usr/' 'usr/local/'; do
	if [ -z "$lib" ]; then
		echo "m ${x}lib"
	else
		echo "m ${x}lib32"
		echo "m ${x}lib64"
		echo "l ${x}lib $lib"
	fi
done
