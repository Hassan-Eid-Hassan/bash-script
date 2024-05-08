#!/bin/bash

# Exit the script on any command failure
set -e

# SonarQube version and download URL
SONARQUBE_VERSION="9.9.0.65466"
SONARQUBE_DOWNLOAD_URL="https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONARQUBE_VERSION}.zip"

# Installation directory
INSTALL_DIR="/opt/sonarqube"
# SonarQube data directory
DATA_DIR="/opt/sonarqube_data"
# SonarQube user and group
SONARQUBE_USER="sonarqube"
SONARQUBE_GROUP="sonarqube"
SONARQUBE_DB_USER="sonr"
SONARQUBE_DB_PASS="sonr"
SONARQUBE_DB_NAME="sonarqube"
PG_DB_SERVER_IP="172.31.71.94"

# Function to install necessary dependencies
install_dependencies() {
    echo "Updating system packages..."
    sudo yum update -y

    echo "Installing dependencies..."
    sudo yum install -y unzip java-17-amazon-corretto-devel
    echo "Dependencies installed."
}

# Function to download and extract SonarQube
install_sonarqube() {
    echo "Downloading SonarQube..."
    wget -q $SONARQUBE_DOWNLOAD_URL -O /tmp/sonarqube.zip

    echo "Extracting SonarQube..."
    sudo unzip /tmp/sonarqube.zip -d /opt
    sudo mv /opt/sonarqube-$SONARQUBE_VERSION $INSTALL_DIR
    echo "SonarQube installed in $INSTALL_DIR."
}

# Function to create a SonarQube user and group
create_sonarqube_user_group() {
    echo "Creating SonarQube user and group..."
    sudo groupadd $SONARQUBE_GROUP || true
    sudo useradd --system -g $SONARQUBE_GROUP -d $INSTALL_DIR -s /bin/false $SONARQUBE_USER || true
    echo "SonarQube user and group created."
}

# Function to configure SonarQube
configure_sonarqube() {
    echo "Configuring SonarQube..."

    #elasticsearch config
    sysctl -w vm.max_map_count=262144

    # Set SonarQube data directory permissions
    sudo mkdir -p $DATA_DIR
    sudo chown -R $SONARQUBE_USER:$SONARQUBE_GROUP $DATA_DIR
    sudo chown -R $SONARQUBE_USER:$SONARQUBE_GROUP $INSTALL_DIR

    # Update SonarQube configuration
    sed -i "s|#sonar.jdbc.username=|sonar.jdbc.username="$SONARQUBE_DB_USER"|" $INSTALL_DIR/conf/sonar.properties
    sed -i "s|#sonar.jdbc.password=|sonar.jdbc.password="$SONARQUBE_DB_PASS"|" $INSTALL_DIR/conf/sonar.properties
    sed -i "s|#sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube?currentSchema=my_schema|sonar.jdbc.url=jdbc:postgresql://$PG_DB_SERVER_IP/sonarqube|" $INSTALL_DIR/conf/sonar.properties
    sed -i "s|#sonar.path.data=data|sonar.path.data=$DATA_DIR|" $INSTALL_DIR/conf/sonar.properties
    sed -i "s|#sonar.path.logs=logs|sonar.path.logs=$INSTALL_DIR/logs|" $INSTALL_DIR/conf/sonar.properties
    echo "SonarQube configured."
}

# Function to create SonarQube systemd service
create_sonarqube_service() {
    echo "Creating SonarQube systemd service..."
    sudo tee /etc/systemd/system/sonarqube.service > /dev/null <<EOF
[Unit]
Description=SonarQube
After=syslog.target network.target

[Service]
Type=forking
ExecStart=$INSTALL_DIR/bin/linux-x86-64/sonar.sh start
ExecStop=$INSTALL_DIR/bin/linux-x86-64/sonar.sh stop
User=$SONARQUBE_USER
Group=$SONARQUBE_GROUP
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    sudo systemctl daemon-reload
    sudo systemctl enable sonarqube
    echo "SonarQube service created and enabled."
}

# Function to start SonarQube
start_sonarqube() {
    echo "Starting SonarQube..."
    sudo systemctl start sonarqube
    echo "SonarQube started."
}

# Function to display access information
display_access_information() {
    echo "SonarQube has been installed and configured."
    local ip_address
    ip_address=$(hostname -I | awk '{print $1}')
    
    echo "You can access SonarQube at: http://$ip_address:9000"
    echo "The default username is 'admin' and the default password is also 'admin'."
}

# Main function to execute all steps
main() {
    install_dependencies
    install_sonarqube
    create_sonarqube_user_group
    configure_sonarqube
    create_sonarqube_service
    start_sonarqube
    display_access_information
}

# Run the main function
main