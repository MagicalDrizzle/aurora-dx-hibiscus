#!/usr/bin/env bash
set -oue pipefail

# KDE customization
curl -sL -o /tmp/symlinks-italic.patch https://invent.kde.org/plasma/plasma-desktop/-/merge_requests/4117.patch
patch -p4 -i /tmp/symlinks-italic.patch -d /usr/share/plasma/plasmoids/org.kde.desktopcontainment

curl -sL -o /tmp/lockscreen-blur-toggle.patch https://invent.kde.org/plasma/plasma-desktop/-/merge_requests/4119.patch
patch -p2 -i /tmp/lockscreen-blur-toggle.patch -d /usr/share/plasma/shells/org.kde.plasma.desktop

# Miscellaneous
grep -qF defaultyes=True /etc/dnf/dnf.conf || printf '%s\n' defaultyes=True >> /etc/dnf/dnf.conf
# pesign doesn't have sysusers, fixed in F45
[ -f /usr/lib/sysusers.d/pesign.conf ] || printf '%s\n' "u pesign - 'Group for the pesign signing daemon' /run/pesign -" > /usr/lib/sysusers.d/pesign.conf
