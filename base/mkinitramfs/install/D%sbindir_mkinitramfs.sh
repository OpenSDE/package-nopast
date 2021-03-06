#!/bin/sh
# --- SDE-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
#
# Filename: package/.../mkinitramfs/install/D%sbindir_mkinitramfs.sh
# Copyright (C) 2007 - 2009 The OpenSDE Project
#
# More information can be found in the files COPYING and README.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- SDE-COPYRIGHT-NOTE-END ---

root=
kernever=
template=
suffix=
running=

mkinitrd_usage() {
	cat <<EOT
Usage: ${0##*/} [ -R <root> ] [ -T <template> ] [ -s <suffix>] [<kernelver>]
	root.....: location of the sandbox to work in (default: /)
	template.: file to use as template for this image
	           (default: \$root/boot/initrd.img)
	kernelver: kerner version to use when grabbing the modules.
	           (default: $( uname -r ))
EOT
}

while [ $# -gt 0 ]; do
	case "$1" in
		-R)	root="$2"; shift ;;
		-T)	template="$2"; shift ;;
		-s)	suffix="$2"; shift ;;
		[0-9]*)	kernelver="$1" ;;
		*)	mkinitrd_usage; exit 1 ;; 
	esac
	shift
done

# $root - root of the sandbox
[ "$root" ] || root="/"
if [ ! -d "$root" ]; then
	echo "ERROR: '$root' is not a directory"
	mkinitrd_usage
	exit 2
else
	root=$( cd "$root"; pwd -P )
	[ "$root" != "/" ] || root=""

	[ -z "$root" ] || echo "root: $root"
fi


# $kernelver - kernel version, only useful if we have modules
if [ -z "$kernelver" ]; then
	kernelver=$( uname -r )
	running=yes
fi

# $template - cpio.gz file to use as base for this initrd
[ "$template" ] || template="${root}/boot/initrd.img"
if [ ! -r "$template" ]; then
	echo "ERROR: template '$template' not found."
	mkinitrd_usage
	exit 3
else
	# skip readlink -f as dependency
	x="${template##*/}"
	[ "$x" != "$template" ] || template="$PWD/$x"
	[ "${template:0:1}" == "/" ] || template="$PWD/$template"
	template="$( cd "${template%/*}"; pwd -P )/$x"
fi

moddir="${root}/lib/modules/$kernelver"
sysmap="${root}/boot/System.map_$kernelver"
libdir="${root}D_libdir"
if [ -d "$moddir" ]; then
	echo "kernel: $kernelver, module dir: ${moddir#$root/}"
	if [ ! -r "$sysmap" ]; then
		echo "ERROR: System.map file not found."
		mkinitrd_usage
		exit 4
	fi
else
	echo "kernel: $kernelver, no modules found."
	moddir=
fi

if [ $UID -ne 0 ]; then
	echo "ERROR: only root can run $0."
	mkinitrd_usage
	exit 5
fi

for tool in mktemp cpio gzip gunzip; do
	if [ -z "$( type -p $tool )" ]; then
		echo "ERROR: $tool is no available"
		exit 6
	fi
done

tmpdir=$( mktemp -d )
olddir="$PWD"
cd "$tmpdir"

# here we go, extract the template
echo "Extracting '${template#$root/}' into '$tmpdir'..."
gunzip -c < "$template" | cpio -i
if [ $? -eq 0 ]; then
	errno=0

	# prepare the environment for the plugins
	export root tmpdir kernelver moddir libdir sysmap running

	# call the plugins
	plugindir="etc/mkinitramfs.d"
	[ -d "$plugindir" ] || plugindir="$libdir"

	for x in "$plugindir"/*.sh; do
		[ -s "$x" ] || continue
		echo "Calling ${x#$plugindir/}"
		$SHELL "$x" || errno=$?

		[ $errno -eq 0 ] || break
	done

	# repack if everything went well
	if [ $errno -eq 0 ]; then
		initrd="boot/initrd-${suffix:-$kernelver}.img"

		echo "Expanded size: $( du -sh . | cut -d' ' -f1 )"
		echo "Repacking '$tmpdir' into \$root/$initrd"
		find . | grep -v '^./etc/mkinitramfs.d' |
			cpio -o -H newc | gzip -9 > "$root/$initrd.$$"

		if [ $? -eq 0 ]; then
			mv -f "$root/$initrd.$$" "$root/$initrd"
			du -sh "$root/$initrd"
			cd "$olddir"; rm -rf "$tmpdir"

			echo "done."
			exit 0
		else
			rm -f "$root/$initrd.$$"
		fi
	fi
fi

cd "$olddir"; rm -rf "$tmpdir"

echo "failed."
exit 1
