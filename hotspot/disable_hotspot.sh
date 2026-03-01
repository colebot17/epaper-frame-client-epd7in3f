#!/bin/bash

sudo systemctl stop hostapd
sudo mv /etc/netplan/70-hotspot.yaml /etc/netplan/70-hotspot.yaml.disabled
sudo systemctl restart systemd-networkd