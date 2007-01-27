if grep -q '^CONFIG_IEEE80211' "$1"; then
	sed -r -e "s:^(CONFIG_IEEE80211.*):#\1:" \
		"$1" > "$1.ieee80211"
	diff -u "$1"{,.ieee80211}
	mv "$1"{.ieee80211,}
fi

if grep -q '^CONFIG_IEEE80211' "include/linux/autoconf.h" 2> /dev/null; then
	sed -r -e "s:^(#(un)?def.*CONFIG_IEEE80211.*):/*\1*/:" \
		"include/linux/autoconf.h" > "include/linux/autoconf.h.ieee80211"
	diff -u "include/linux/autoconf.h"{,.ieee80211}
	mv -v "include/linux/autoconf.h"{.ieee80211,}
fi
