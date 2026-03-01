#!/bin/bash
set -e

APP_DIR=$(pwd)

echo "Updating epaper application..."

git fetch && git reset --hard origin/main
$APP_DIR/venv/bin/pip install -r $APP_DIR/requirements.txt
chmod +x enable.sh disable.sh update.sh install_hotspot.sh
$APP_DIR/enable.sh