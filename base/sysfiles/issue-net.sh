# --- SDE-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
#
# Filename: package/.../sysfiles/issue-net.sh
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

cat > etc/issue.net << EOT

%d  --  line [%t].

Welcome to %h ($rocktxt).

EOT
