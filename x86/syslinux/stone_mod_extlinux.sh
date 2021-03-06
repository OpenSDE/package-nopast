# --- SDE-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
#
# Filename: package/.../syslinux/stone_mod_extlinux.sh
# Copyright (C) 2006 - 2008 The OpenSDE Project
# Copyright (C) 2004 - 2006 The T2 SDE Project
# Copyright (C) 1998 - 2003 Clifford Wolf
#
# More information can be found in the files COPYING and README.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- SDE-COPYRIGHT-NOTE-END ---
#
# [MAIN] 70 extlinux extlinux (syslinux) Boot Loader Setup
# [SETUP] 90 extlinux

rootdev_cache=
bootdev_cache=
bootdrive_cache=

rootdev()
{
	[ -n "$rootdev_cache" ] || rootdev_cache=$(
					grep '^/dev/.* / ' /proc/mounts |
					head -n 1 | cut -d' ' -f1 )
	echo "$rootdev_cache"
}

bootdev()
{
	[ -n "$bootdev_cache" ] || bootdev_cache=$(
					grep '^/dev/.* /boot ' /proc/mounts |
					head -n 1 | cut -d' ' -f1 )
	[ -n "$bootdev_cache" ] || bootdev_cache=$( rootdev )
	echo "$bootdev_cache"
}

bootdrive()
{
	[ -n "$bootdrive_cache" ] || bootdrive_cache=$(
					bootdev | sed -r 's/p?[0-9]*$//' )
	echo "$bootdrive_cache"
}

extlinux_kernel_list()
{
	local label= first=1 initrd= x=
        for x in `(cd /boot/ ; ls -1 vmlinuz_* ) | sort -r` ; do
                if [ $first = 1 ] ; then
                        label=linux ; first=0
                else
                        label=linux-${x/vmlinuz_/}
                        label=${label/-dist/}
                fi
		initrd=initrd-${x/vmlinuz_/}.img

                cat <<-EOT

		LABEL $label
		    KERNEL  /$x
		    APPEND  initrd=/$initrd root=$( rootdev ) ro
		EOT
        done
}

extlinux_create_conf()
{
	mkdir -p $extlinuxdir

	cat > $extlinuxconf <<-EOT
	DEFAULT linux
	PROMPT 1
	TIMEOUT 300
	EOT

	extlinux_kernel_list >> $extlinuxconf

	gui_message "This is the new $extlinuxconf file:

$( cat $extlinuxconf )"

}

extlinux_install()
{
	gui_cmd "Installing extlinux in $extlinuxdir" \
		"mkdir -p $extlinuxdir; extlinux -i $extlinuxdir"
}

extlinux_clean_mbr()
{
	cat /usr/share/syslinux/mbr.bin > "$1"
}

main()
{
	local extlinuxdir=/boot/extlinux
	local extlinuxconf=$extlinuxdir/extlinux.conf
	local drive=$( bootdrive )

	while gui_menu extlinux 'Extlinux (syslinux) Boot Loader Setup' \
                '(Re-)Create extlinux.conf with installed kernels' 'extlinux_create_conf' \
                "(Re-)Install extlinux in $extlinuxdir" 'extlinux_install' \
		"Clean $drive's MBR (use with care)" "extlinux_clean_mbr '$drive'" \
                "Edit $extlinuxconf (recommended)" \
						"gui_edit 'Extlinux Config File' $extlinuxconf"
	do : ; done
}

