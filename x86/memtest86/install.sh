#!/bin/sh
#
# --- T2-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
#
# T2 SDE: package/.../memtest86/install.sh
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

echo
echo "This script will create a memtest86 boot floppy."
echo
echo "Please insert an empty disk to floppy drive 0 and press ENTER to"
echo "continue or Ctrl-C to abort."
read

if dd if=/boot/memtest.bin of=/dev/floppy/0 bs=8192
then
	echo
	echo "The memtest86 boot floppy has been successfully created."
	echo "Have fun with memtest86."
	echo
else
	echo
	echo "THERE HAVE BEEN AN ERROR WHILE WRITING TO /dev/floppy/0 !!"
	echo
	echo "Please check the floppy disk and your permissions and try again."
	echo
fi

