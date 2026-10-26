#!/usr/bin/env bash
set -oue pipefail

curl_gh() {
  command curl -sL \
    -H "Authorization: Bearer $GH_TOKEN" \
    -H "Accept: application/vnd.github+json" \
    "$@"
}

# Hermes
kver="$(rpm -q --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}\n' kernel-core | sort -V | tail -n1)"
dnf5 -y install "$(curl_gh https://api.github.com/repos/MrOz59/Hermes/releases \
    | jq -r --arg ver "$OS_VERSION" '[.[0].assets[].browser_download_url] |
    (map(select(contains(".fc" + $ver))).[0]) // (map(select(contains(".fc"))) | sort[-1])')"

# Hermes-KMS
git clone https://github.com/MrOz59/Hermes-KMS.git --single-branch \
    -b "$(curl_gh 'https://api.github.com/repos/MrOz59/Hermes-KMS/tags' | jq -r '.[0].name')" /tmp/hermes-kms
cd /tmp/hermes-kms
make modules KERNELRELEASE="${kver}" KDIR="/usr/lib/modules/${kver}/build" && \
make modules-install KERNELRELEASE="${kver}" DESTDIR=/
"/usr/lib/modules/${kver}/build/scripts/sign-file" sha512 /tmp/SB_KEY /tmp/SB_CERT \
    "/usr/lib/modules/${kver}/extra/hermes-kms/hermes_kms.ko"
