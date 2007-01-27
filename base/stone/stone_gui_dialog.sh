# --- T2-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
# 
# T2 SDE: package/.../stone/stone_gui_dialog.sh
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
# Filename: gui_dialog.sh
# Description:
# ============
# This file provides the gui-functions implemented with
# the use of dialog, i.e. a curses based menu-frontend.

gui_dialog_lines="$(   stty size | cut -d' ' -f1 )"
gui_dialog_columns="$( stty size | cut -d' ' -f2  )"

gui_dialog_s70=$(( gui_dialog_columns - 10 ))
gui_dialog_s62=$(( gui_dialog_columns - 18 ))
gui_dialog_s15=$(( gui_dialog_lines - 10 ))

gui_dialog() {
	dialog --stdout --title 'STONE - Setup Tool ONE - T2 System Configuration' "$@"
}


# [ the following variables act as staticly declared variables in functions (in
#   C), i.e. they keep their content even after return of the certain function
#   to be used again and again in this function. ]
# 
# Important is to know that an element of `gui_menu_tree_name' corresponds
# to an element of `gui_menu_tree_value' by the same number, i.e.
#      gui_menu_tree_value[0] contains the value of gui_menu_tree_name[0]
#
declare -a gui_menu_tree_name
declare -a gui_menu_tree_value
gui_menu_tree_id=-1

# Use: gui_menu "ID" "Title" "Text" "Action" [ "Text" "Action" [ .. ] ]
#
gui_menu() {
	# `cmd_ar' acts as a kind of mapper between the choosen category
	# and the function's/command's name that is responsible for what 
	# next is to do. This command/function is finally executed.
	local -a cmd_ar

	# Although dialog does folding itself, we're forced
	# to do it directly, because we need the number of
	# lines to compute the size of a widget.
	local id="$1" title="$( echo "$2" | fmt -$gui_dialog_s62 )"
	local y_text=$( echo "$title" | wc -l ) y_menu=$(( ($#-2) / 2 ))
	local nr=1 x="'" y choosen='' ; shift 2

	[ $(( $y_text + $y_menu )) -gt $gui_dialog_s15 ] && \
				y_menu=$(( gui_dialog_s15 - y_text ))

	if [ $id = main ] ; then local cmd="gui_dialog --cancel-label Exit"
	elif [ "$gui_nocancel" = 1 ] ; then cmd="gui_dialog --no-cancel"
	else local cmd="gui_dialog --cancel-label Back" ; fi

	# In case of having been in the current menu before (found out by
	# checking the current ID for the ones saved in `gui_menu_tree_name[]'),
	# make the old item be cursored again.
	local default='' count
	for (( count=$gui_menu_tree_id; $count >= 0; count-- )) 
	do
		if [ "${gui_menu_tree_name[$count]}" = $id ] ; then
			default="${gui_menu_tree_value[$count]}"
			gui_menu_tree_id=$(( $count - 1 ))
			break
		fi
	done

	cmd="$cmd --default-item \${default:-0}"
	cmd="$cmd --menu '${title//$x/$x\\$x$x}'"
	cmd="$cmd $(( $y_text + $y_menu +  6 )) $gui_dialog_s70 $y_menu"

	while [ $# -gt 0 ] ; do
		y="${2#\*}"
		if [ -z "$default" -a "$y" != "$2" ] ; then
			default="$nr"
		fi
		if [ -z "$y" ] ; then
			if [ -z "$1" ] ; then
				# this line should become a blank one
				cmd="$cmd ' ' ' '"
			else
				# the purpose of this line is only to
				# display additional information about
				# the item before
				cmd="$cmd '-' '${1//$x/$x\\$x$x}'"
			fi
		else
			cmd="$cmd $nr '${1//$x/$x\\$x$x}'"
			cmd_ar[$nr]="$y"
			((nr++))
		fi

		shift ; shift
	done

	# `choosen' gets the choosen item that represents in fact
	# the dereferencer for `cmd_ar'.
	choosen="$(eval "$cmd")"

	if [ $? -eq 0 ]; then
		# if enter is pressed on an ``additional information line'',
		# do nothing.
		[ "$choosen" = "-" ] && return 0

		gui_menu_tree_id=$(( $gui_menu_tree_id + 1 ))
		gui_menu_tree_name[$gui_menu_tree_id]=$id
		gui_menu_tree_value[$gui_menu_tree_id]=$choosen

		eval "${cmd_ar[$choosen]}"
		return 0
	else
		return 1
	fi
}

# Use: gui_input "Text" "Default" "VarName"
#
gui_input() {
	local headlines="$( echo "$1" | fmt -$gui_dialog_s62 )"	\
	      height=$(( $(echo "$headlines" | wc -l) + 7 )) tmp cmd

	if [ "$gui_nocancel" = 1 ] ; then cmd="gui_dialog --no-cancel"
	else local cmd="gui_dialog --cancel-label Back" ; fi

	if tmp="$($cmd --inputbox "$headlines" $height $gui_dialog_s70 "$2")"; then 
		eval "$3='$tmp'"
	fi
}

# Use: gui_message "Text"
#
gui_message() {
	local headlines="$( echo "$1" | fmt -$gui_dialog_s62 )"
	gui_dialog --msgbox "$headlines" \
		$(( $( echo "$headlines" | wc -l ) + 4 )) $gui_dialog_s70
}

# Use: gui_yesno "Text"
#
gui_yesno() {
	local headlines="$( echo "$1" | fmt -$gui_dialog_s62 )"
	gui_dialog --yesno "$headlines" \
		$(( $( echo "$headlines" | wc -l ) + 4 )) $gui_dialog_s70
}


# Use: gui_edit "Text" "File"
#
gui_edit() {
	# find editor
	for x in $EDITOR vi nvi emacs xemacs pico ; do
		if type -p $x > /dev/null
		then xx=$x ; break ; fi
	done
	if [ "$xx" ] ; then
		eval "$xx $2"
	else
		gui_message "Cannot find any editor. Make sure \$EDITOR is set."
	fi
}

# Use: gui_cmd "Title" "Command"
# (Title isn't used in this GUI type)
gui_cmd() {
	shift ; eval "$@"
	read -p "Press ENTER to continue."
}
