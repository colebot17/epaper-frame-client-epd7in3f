#!/bin/bash
set -e

sleep 10

if ! networkctl is-online --interface=eth0 --quiet; then
    /etc/networkd-dispatcher/off.d/enable_hotspot.sh
fi