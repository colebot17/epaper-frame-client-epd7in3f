#!/bin/bash

sudo mv /etc/netplan/70-hotspot.yaml.disabled /etc/netplan/70-hotspot.yaml
sudo netplan apply
sudo systemctl start hostap