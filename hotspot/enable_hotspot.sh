#!/bin/bash

APP_DIR=$(pwd)

sudo cp $APP_DIR/hotspot/70-hotspot.yaml /etc/netplan/70-hotspot.yaml
sudo chmod 600 /etc/netplan/70-hotspot.yaml
sudo netplan apply
sudo systemctl start hostapd