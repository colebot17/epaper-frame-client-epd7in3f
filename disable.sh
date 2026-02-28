#!/bin/bash

SERVICE_NAME="epaper.service"
SERVICE_PATH="/etc/systemd/system/$SERVICE_NAME"

echo "#######################"
echo "## Disabling Service ##"
echo "#######################"
echo ""
sudo systemctl stop $SERVICE_NAME
sudo systemctl disable $SERVICE_NAME
sudo rm -f $SERVICE_PATH
sudo systemctl daemon-reload
echo "Service stopped and disabled."