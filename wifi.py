import yaml
import subprocess

def generate_netplan(networks):
    # define a default config skeleton with HappyFish
    netplan_config = {
        "network": {
            "version": 2,
            "wifis": {
                "wlan0": {
                    "dhcp": True,
                    "access-points": {
                        "HappyFish": {
                            "password": "s*n!%o@!?u"
                        }
                    }
                }
            }
            
        }
    }
    
    # add all other networks
    for network in networks:
        netplan_config["network"]["wifis"]["wlan0"]["access-points"][network["ssid"]] = {
            "password": network["password"]
        }
    
    # save and apply the netplan
    netplan_path = "/etc/netplan/60-wifi.yaml"
    with open(netplan_path, "w") as f:
        yaml.safe_dump(netplan_config, f, default_flow_style=False)
    subprocess.run(["chmod", "600", netplan_path], check=True)
    subprocess.run(["netplan", "apply"], check=True)