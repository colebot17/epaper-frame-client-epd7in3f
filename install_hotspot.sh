APP_DIR=$(pwd)

echo "Enabling automatic hotspot..."

# copy scripts to enable/disable hotspot
sudo cp $APP_DIR/hotspot/enable_hotspot.sh /etc/networkd-dispatcher/off.d/enable_hotspot.sh
sudo cp $APP_DIR/hotspot/disable_hotspot.sh /usr/local/bin/disable_hotspot.sh

# copy startup check script
sudo cp $APP_DIR/hotspot/network_check_startup.sh /usr/local/bin/network_check_startup.sh

# set script permissions
sudo chmod +x /etc/networkd-dispatcher/off.d/enable_hotspot.sh /usr/local/bin/network_check_startup.sh /usr/local/bin/disable_hotspot.sh

# copy and enable startup service (oneshot)
sudo cp $APP_DIR/hotspot/network_check_startup.service /etc/systemd/system/network_check_startup.service
sudo systemctl daemon-reload
sudo systemctl enable network_check_startup.service

# copy and point to hostapd config file
sudo cp $APP_DIR/hotspot/hostapd.conf /etc/hostapd/hostapd.conf
sudo sed -i 's|^#\?DAEMON_CONF=.*|DAEMON_CONF="/etc/hostapd/hostapd.conf"|' /etc/default/hostapd

# create an ap interface
sudo iw dev wlan0_ap del
sudo iw dev wlan0 interface add wlan0_ap type __ap
sudo ip addr add 192.168.50.1/24 dev wlan0_ap
sudo ip link set wlan0_ap up

# unmask hostapd
sudo systemctl unmask hostapd

# configure and enable dnsmasq (for dhcp)
sudo cp $APP_DIR/hotspot/dnsmasq.conf /etc/dnsmasq.conf
sudo systemctl enable dnsmasq
sudo systemctl restart dnsmasq

# run oneshot startup service
sudo systemctl start network_check_startup.service

echo "Hotspot installed"