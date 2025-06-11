#!/bin/bash
# Minecraft Server Auto-Install Script
# This script assumes it's being run as root or with sudo privileges

# Configuration variables
MINECRAFT_USER="minecraft"
INSTALL_DIR="/opt/minecraft/server"
SERVER_JAR_URL="https://piston-data.mojang.com/v1/objects/e6ec2f64e6080b9b5d9b471b291c33cc7f509733/server.jar"
MEMORY_ALLOCATION="1300M"

# Update system and install Java (headless)
sudo apt-get update -y
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:openjdk-r/ppa
sudo apt-get update -y
sudo apt-get install -y openjdk-21-jre-headless

# Create minecraft user and directories
adduser --system --no-create-home --group $MINECRAFT_USER
mkdir -p $INSTALL_DIR
chown -R $MINECRAFT_USER:$MINECRAFT_USER /opt/minecraft

# Download Minecraft server
cd $INSTALL_DIR
sudo -u $MINECRAFT_USER wget $SERVER_JAR_URL -O server.jar

# Create start script
cat > start.sh <<EOF
#!/bin/bash
java -Xmx${MEMORY_ALLOCATION} -Xms${MEMORY_ALLOCATION} -jar server.jar nogui
EOF

# Create stop script
cat > stop.sh <<EOF
#!/bin/bash
kill -9 \$(pgrep -f "java.*server.jar")
EOF

# Make scripts executable
chmod +x start.sh stop.sh
chown $MINECRAFT_USER:$MINECRAFT_USER *.sh

# First run to generate files and accept EULA
sudo -u $MINECRAFT_USER java -Xmx${MEMORY_ALLOCATION} -Xms${MEMORY_ALLOCATION} -jar server.jar nogui || true
sudo -u $MINECRAFT_USER sed -i 's/eula=false/eula=true/' eula.txt

# Create systemd service
cat > /etc/systemd/system/minecraft.service <<EOF
[Unit]
Description=Minecraft Server
After=network.target

[Service]
User=$MINECRAFT_USER
WorkingDirectory=$INSTALL_DIR
ExecStart=$INSTALL_DIR/start.sh
ExecStop=$INSTALL_DIR/stop.sh
Restart=always
RestartSec=3
StandardOutput=journal
StandardError=journal
Environment="JAVA_OPTS=-Xms${MEMORY_ALLOCATION} -Xmx${MEMORY_ALLOCATION}"

[Install]
WantedBy=multi-user.target
EOF

# Enable and start service
systemctl daemon-reload
systemctl enable minecraft.service
systemctl start minecraft.service

echo "Complete"