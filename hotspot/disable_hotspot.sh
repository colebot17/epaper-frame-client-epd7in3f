#!/bin/bash

sudo systemctl stop hostapd
sudo rm -f /etc/netplan/70-hotspot.yaml
sudo netplan apply