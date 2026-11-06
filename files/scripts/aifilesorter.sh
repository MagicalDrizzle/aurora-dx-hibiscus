#!/usr/bin/env bash
set -oue pipefail

cd /tmp
curl -O https://filesorter.app/download/$(curl -s https://filesorter.app/download/ | grep -Eo 'aifilesorter-linux-fedora.+\.zip')
unzip aifilesorter-linux-fedora*.zip
dnf5 -y install aifilesorter*.rpm
