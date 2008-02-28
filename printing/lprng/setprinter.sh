#!/bin/sh
# --- SDE-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
#
# Filename: package/.../lprng/setprinter.sh
# Copyright (C) 2008 The OpenSDE Project
# Copyright (C) 2004 - 2006 The T2 SDE Project
#
# More information can be found in the files COPYING and README.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- SDE-COPYRIGHT-NOTE-END ---

root=
if [ "x$1" = "x-R" ]; then
	root="$2"
	shift; shift
fi

for x in cancel lp lpq lpr lprm lpstat; do
	echo "$0: Re-creating /usr/bin/$x -> ${x}_@printer@ ..."
	cat <<-EOF > "$root/usr/bin/$x"
	#!/bin/sh
	# this file was generated by setprinter_@printer@
	#
	
	exec -a $x ${x}_@printer@ "\$@"
	EOF
	chmod +x "$root/usr/bin/$x"
done

for x in lpc; do
	echo "$0: Re-creating /usr/sbin/$x -> ${x}_@printer@ ..."
	cat <<-EOF > "$root/usr/sbin/$x"
	#!/bin/sh
	# this file was generated by setprinter_@printer@
	#
	
	exec -a $x ${x}_@printer@ "\$@"
	EOF
	chmod +x "$root/usr/sbin/$x"
done

exit 0

