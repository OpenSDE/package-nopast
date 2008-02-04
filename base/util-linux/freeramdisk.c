/*
 * --- T2-COPYRIGHT-NOTE-BEGIN ---
 * This copyright note is auto-generated by ./scripts/Create-CopyPatch.
 *
 * T2 SDE: package/.../util-linux/freeramdisk.c
 * Copyright (C) 2004 - 2006 The T2 SDE Project
 *
 * More information can be found in the files COPYING and README.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License. A copy of the
 * GNU General Public License can be found in the file COPYING.
 * --- T2-COPYRIGHT-NOTE-END ---
 */
#include <stdio.h>
#include <string.h>
#include <sys/mount.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <errno.h>

int main(int argc, char **argv)
{
	int c, f, rc=0;

	if (argc == 1) {
		fprintf(stderr,"Usage: %s /dev/rd/initrd "
			       "[ /dev/rd/12 [ .. ] ]\n", argv[0]);
		return 1;
	}

	for (c=1; c < argc; c++) {
		if ((f=open(argv[c], O_RDWR)) == -1) {
			fprintf(stderr, "freeramdisk: cannot open %s: %s\n",
			                argv[c], strerror(errno));
			rc++;
		} else {
			ioctl(f, BLKFLSBUF);
			close(f);
		}
	}
	return rc;
}

