# Written by Logan Flecke

# Install the Wazuh Indexer, Server, and Dashboard on a single host and reset the password

host_ip="192.168.1.10"

# Download installation and configuration files
curl -sO https://packages.wazuh.com/4.9/wazuh-install.sh
curl -sO https://raw.githubusercontent.com/loganflecke/Home-Lab/refs/heads/main/wazuh_custom_config.yml
mv wazuh_custom_config.yml config.yml

bash wazuh-install.sh --generate-config-files

# Install the indexer, server, and dashboard
bash wazuh-install.sh --wazuh-indexer node-1
bash wazuh-install.sh --start-cluster

bash wazuh-install.sh --wazuh-server wazuh-1

bash wazuh-install.sh --wazuh-dashboard dashboard

# Reset the password for the web interface
cd /var/ossec/bin
curl -so wazuh-passwords-tool.sh https://packages.wazuh.com/4.7/wazuh-passwords-tool.sh
bash wazuh-passwords-tool.sh -u admin -p P*ssw0rd

service wazuh-dashboard restart
