#!/bin/sh

log="/var/log/pacman.log"

ts=$(grep "Running 'pacman -Syu'" "$log" | tail -n 1 | sed -E 's/^\[([^]]+)\].*/\1/')

last=$(date -d "$ts" +%s)
now=$(date +%s)
diff=$((now - last))

days=$((diff / 86400))
hours=$(((diff % 86400) / 3600))
minutes=$(((diff % 3600) / 60))

printf "Last full system upgrade: "

[ "$days" -gt 0 ] && printf "%d days ago\n" "$days"
[ "$hours" -gt 0 ] && printf "%d hours ago\n" "$hours"
printf "%d minutes ago\n" "$minutes"
