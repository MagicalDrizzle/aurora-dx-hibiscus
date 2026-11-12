#!/usr/bin/env bash
set -oue pipefail

# KDE customization
curl -sL -o /tmp/symlinks-italic.patch https://invent.kde.org/plasma/plasma-desktop/-/merge_requests/4117.patch
patch -p4 -i /tmp/symlinks-italic.patch -d /usr/share/plasma/plasmoids/org.kde.desktopcontainment

curl -sL -o /tmp/lockscreen-blur-toggle.patch https://invent.kde.org/plasma/plasma-desktop/-/merge_requests/4119.patch
patch -p2 -i /tmp/lockscreen-blur-toggle.patch -d /usr/share/plasma/shells/org.kde.plasma.desktop

# Miscellaneous
grep -qF defaultyes=True /etc/dnf/dnf.conf || printf '%s\n' defaultyes=True >> /etc/dnf/dnf.conf

# Bazzite
git clone https://github.com/ublue-os/bazzite.git /tmp/bazzite
cd /tmp/bazzite
git checkout $(git tag | grep -Ex '[^a-z]+' | tail -n1)

### bees
rsync -Rr system_files/desktop/shared/./etc/systemd/system/beesd@.service.d/override.conf \
          system_files/desktop/shared/./usr/lib/systemd/system/beesd@.timer \
          system_files/desktop/shared/./usr/share/ublue-os/just/82-bazzite-beesd.just \
          /
echo "import? \"/usr/share/ublue-os/just/82-bazzite-beesd.just\"" >> /usr/share/ublue-os/just/00-entry.just
sed -i -e '/source \/usr\/lib\/ujust\/ujust.sh/d' -e 's/ugum/gum/g' /usr/share/ublue-os/just/82-bazzite-beesd.just

# btrfs-assistant: Match the literal runtime variable in the launcher.
# shellcheck disable=SC2016
sed -i \
    's/ --xdg-runtime=\\"${XDG_RUNTIME_DIR}\\"//g' \
    /usr/bin/btrfs-assistant-launcher

### DXVK
curl "https://raw.githubusercontent.com/doitsujin/dxvk/3a4c6fa3cb1548d56a90a38dd8f526b6c13e63fd/dxvk.conf" \
    -Lo /etc/dxvk-example.conf

### Waydroid
curl "https://raw.githubusercontent.com/ublue-os/waydroid-scripts/main/waydroid-choose-gpu.sh" \
    -Lo /usr/bin/waydroid-choose-gpu
chmod +x /usr/bin/waydroid-choose-gpu

# Patch waydroid-network script and btrfs-assistant-launcher for compatibility.
sed -i~ -E \
    's/=.\$\(command -v (nft|ip6?tables-legacy).*/=/g' \
    /usr/lib/waydroid/data/scripts/waydroid-net.sh

if [[ -f "/var/lib/waydroid/lxc/waydroid/config" ]]; then
  echo "Removing unneeded apparmor entry from Waydroid LXC"
  sed -i '/lxc\.apparmor\.profile\s*=\s*unconfined/d' "/var/lib/waydroid/lxc/waydroid/config"
fi

rsync -Rr system_files/desktop/shared/./usr/bin/waydroid-launcher \
          system_files/desktop/shared/./usr/libexec/waydroid-* \
          system_files/desktop/shared/./usr/share/applications/waydroid-container-restart.desktop \
          system_files/desktop/shared/./usr/share/applications/Waydroid \
          system_files/desktop/shared/./usr/share/polkit-1/actions/org.bazzite.waydroid.policy \
          system_files/desktop/shared/./usr/share/polkit-1/rules.d/30-waydroid.rules \
          system_files/desktop/shared/./usr/share/ublue-os/just/82-bazzite-waydroid.just \
          /
echo "import? \"/usr/share/ublue-os/just/82-bazzite-waydroid.just\"" >> /usr/share/ublue-os/just/00-entry.just
sed -i -e '/source \/usr\/lib\/ujust\/ujust.sh/d' -e 's/ugum/gum/g' /usr/share/ublue-os/just/82-bazzite-waydroid.just
