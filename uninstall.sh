#!/bin/bash

./disable.sh

sudo rm -f /etc/networkd-dispatcher/routable.d/network_up.sh
sudo rm -f /etc/networkd-dispatcher/off.d/network_down.sh
sudo rm -f /usr/local/bin/network_check_startup.sh
sudo rm -f /etc/systemd/system/network_check_startup.service
sudo rm -f /etc/netplan/60-wifi.yaml
sudo rm -f /etc/netplan/70-hotspot.yaml
sudo rm -f /etc/netplan/70-hotspot.yaml.disabled
sudo systemctl disable --now hostapd
sudo rm -f /etc/hostapd/hostapd.conf
sudo sed -i '\|^DAEMON_CONF="/etc/hostapd/hostapd.conf"$|d' /etc/default/hostapd