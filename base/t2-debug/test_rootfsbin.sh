#!/bin/sh
#
# --- T2-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
# 
# T2 SDE: package/.../t2-debug/test_rootfsbin.sh
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
# List binaries which should in in /bin and /sbin and are not there.
#
# Output format:
# Bin-Name <Tab> Should-Be <Tab> { "Not Found" | Current-Location }

bin_fhs='cat chgrp chmod chown cp date dd df dmesg echo ed false
         kill ln login ls mkdir mknod more mount mv ps pwd rm rmdir
         sed setserial sh stty su sync true umount uname
         tar gzip gunzip zcat cpio domainname hostname netstat ping
         sleep bzip2 bunzip2 bzcat'

bin_rock='bash sleep sync sort xargs grep cut skill snice find'

sbin_fhs='clock getty init update mkswap swapon swapoff telinit
          fastboot fasthalt halt reboot shutdown ifconfig route
          fdisk fsck fsck.ext2 fsck.ext3 mkfs mkfs.ext2 badblocks dumpe2fs
          e2fsck mke2fs mklost+found tune2fs lilo ctrlaltdel kbdrate'

sbin_rock='devfsd'

for mode in bin sbin ; do
    for bin in `eval "echo \\$${mode}_fhs \\$${mode}_rock"` ; do
	found_dir=""
	for dir in {,/usr,/usr/local}/{,s}bin /usr/{local/,}games ; do
		[ -f $dir/$bin ] && found_dir=$dir
	done
	if [ -z "$found_dir" ] ; then
		echo -e "$bin\t/$mode\tNot Found"
	elif [ "$found_dir" != "/$mode" ] ; then
		echo -e "$bin\t/$mode\t$found_dir"
	fi
    done
done

exit 0
