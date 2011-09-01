#!/bin/sh
# --- SDE-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
#
# Filename: package/.../sendmail/setmailer.sh
# Copyright (C) 2007 - 2011 The OpenSDE Project
# Copyright (C) 2004 - 2006 The T2 SDE Project
#
# More information can be found in the files COPYING and README.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- SDE-COPYRIGHT-NOTE-END ---

prefix=$( cd ${0%/*}/..; pwd -P )
for x in sendmail mailq newaliases; do
	echo "$0: Re-creating /usr/bin/$x -> ${x}_@mailer@ ..."
	echo -e "#!/bin/sh\nexec -a $prefix/sbin/$x ${x}_@mailer@ \"\$@\"" > $prefix/bin/$x
	chmod +x $prefix/bin/$x
done

# add compatibility symlink
for x in sbin lib; do
	[ -x "$prefix/$x/sendmail" ] || ln -sf ../bin/sendmail $prefix/$x/sendmail
done

exit 0

