#!/bin/bash

# Variables
KIBANA_VERSION="8.9.2"
KIBANA_DOWNLOAD_URL="https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz"
KIBANA_DIR="/usr/share/kibana-${KIBANA_VERSION}"
KIBANA_SERVICE="/etc/systemd/system/kibana.service"

# Update and install dependencies
sudo apt-get update
sudo apt-get install -y wget tar

# Download Kibana
echo "Downloading Kibana version ${KIBANA_VERSION}..."
wget $KIBANA_DOWNLOAD_URL -O kibana-${KIBANA_VERSION}.tar.gz

# Extract Kibana
echo "Extracting Kibana..."
sudo tar -xzf kibana-${KIBANA_VERSION}.tar.gz -C /usr/share/
#sudo mv kibana-${KIBANA_VERSION}.tar.gz $KIBANA_DIR

# Create kibana user and set permissions
echo "Creating Kibana user..."
sudo useradd -r -s /usr/sbin/nologin kibana
sudo chown -R kibana:kibana $KIBANA_DIR

# Create the Kibana service
echo "Setting up Kibana as a service..."
sudo bash -c "cat > $KIBANA_SERVICE" <<EOF
[Unit]
Description=Kibana
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
ExecStart=$KIBANA_DIR/bin/kibana
Restart=always
RestartSec=10
User=kibana
Group=kibana
Environment=KIBANA_HOME=$KIBANA_DIR

[Install]
WantedBy=multi-user.target
EOF

# Reload daemon and enable the service
echo "Reloading systemd and enabling Kibana service..."
sudo systemctl daemon-reload
sudo systemctl enable kibana.service

# Start Kibana service
echo "Starting Kibana service..."
sudo systemctl start kibana.service

# Confirm Kibana service status
echo "Kibana service status:"
sudo systemctl status kibana.service
