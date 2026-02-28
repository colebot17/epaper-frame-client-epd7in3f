#!/bin/bash

APP_DIR=$(pwd)

echo "Updating system packages..."
sudo apt update
sudo apt install -y python3 python3-venv python3-pip python3-pil python3-numpy

echo "Creating virtual environment..."
rm -rf venv
python3 -m venv $APP_DIR/venv

echo "Installing Python dependencies..."
$APP_DIR/venv/bin/pip install --upgrade pip
$APP_DIR/venv/bin/pip install -r $APP_DIR/requirements.txt

./enable.sh

echo "Done."