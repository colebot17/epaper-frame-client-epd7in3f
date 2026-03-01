#!/bin/bash

sudo mv /etc/netplan/70-hotspot.yaml.disabled /etc/netplan/70-hotspot.yaml
sudo systemctl restart systemd-networkd
sudo systemctl start hostap