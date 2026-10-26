#!/usr/bin/env bash
set -oue pipefail

sed -i 's/p1+wk/pn+wk/g' /usr/lib64/beyondcompare/BCompare
git clone https://github.com/garfield-ts/BCompare_Keygen.git /tmp/bc_keygen
python -m venv /tmp/bc_venv && source /tmp/bc_venv/bin/activate
pip3 install base58==2.1.1 pycryptodome==3.24.0
python /tmp/bc_keygen/keygen.py -u Mizuki -c innerworld -s 4462-6498 -n 4464 > /usr/lib64/beyondcompare/BC5Key.txt
deactivate
