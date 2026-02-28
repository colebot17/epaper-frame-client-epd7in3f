#!/bin/bash

APP_DIR=$(pwd)
SERVICE_NAME="epaper.service"
SERVICE_PATH="/etc/systemd/system/$SERVICE_NAME"

echo "######################"
echo "## Enabling Service ##"
echo "######################"
echo ""
sudo cp $APP_DIR/epaper.service $SERVICE_PATH
sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME
sudo systemctl restart $SERVICE_NAME