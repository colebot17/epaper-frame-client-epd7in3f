echo "Enabling automatic hotspot..."

# copy script to run on network down
sudo cp $APP_DIR/hotspot/enable_hotspot.sh /etc/networkd-dispatcher/off.d/enable_hotspot.sh

# copy startup check script
sudo cp $APP_DIR/hotspot/network_check_startup.sh /usr/local/bin/network_check_startup.sh

# set script permissions
sudo chmod +x /etc/networkd-dispatcher/off.d/enable_hotspot.sh /usr/local/bin/network_check_startup.sh /usr/local/bin/disable_hotspot.sh

# copy and enable startup service (oneshot)
sudo cp $APP_DIR/hotspot/network_check_startup.service /etc/systemd/system/network_check_startup.service
sudo systemctl daemon-reload
sudo systemctl enable network_check_startup.service
sudo systemctl restart network_check_startup.service

# copy disabled netplan file for hotspot
sudo cp $APP_DIR/hotspot/70-hotspot.yaml /etc/netplan/70-hotspot.yaml.disabled

# copy and point to hostapd config file
sudo cp $APP_DIR/hotspot/hostapd.conf /etc/hostapd/hostapd.conf
echo 'DAEMON_CONF="/etc/hostapd/hostapd.conf"' >> /etc/default/hostapd

# unmask hostapd
sudo systemctl unmask hostapd