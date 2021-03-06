#!/bin/sh
# --- SDE-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
#
# Filename: package/.../runit/overlay.d/runit/D%sbindir_runit-run.sh
# Copyright (C) 2010 The OpenSDE Project
#
# More information can be found in the files COPYING and README.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- SDE-COPYRIGHT-NOTE-END ---
#
# to be used as symlink to /etc/runit/runit-run or #!/etc/runit/runit-run

exec 2>&1

. D_libdir/runit-run.in

set -e

SVID="${PWD##*/}"
RUN=
RUNOPT=

[ -z "$SCRIPT" ] || . "$PROGNAME"

if [ -n "$RUN" ]; then
	[ -z "$RUNOPT" ] || eval "set -- $RUNOPT $*"
	exec "$RUN" "$@"
else
	echo "$PROGNAME: no daemon to RUN defined" >&2
	exit 1
fi
