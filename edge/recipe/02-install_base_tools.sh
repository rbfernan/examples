#!/bin/bash

# Setup Instructions:
# 1. Create an org and a Gateway type (enable Edge Services)
# 2. Create a new device for the Gateway Type
# 3. Generate an API-Key and token
# 5. Update the export section of thi script with the appropriate values
# 6. Run it (as root) in a ubuntu 16 system in order to configure the Edge node
# 

# based on the  https://github.com/open-horizon/examples/wiki/Edge-Quick-Start-Developer-Guide
# Note: requires some of the steps require root access
echo "Setting up tools and base environment ..." 
. ~/hzn_custom_wl_demo.env

# Configure docker, horizon repos for installation

if [ -x "$(command -v docker)" ]; then
    echo "docker already installed"
else
    echo "Install docker"
    curl -fsSL get.docker.com | sh
    # command
fi

wget -qO - http://pkg.bluehorizon.network/bluehorizon.network-public.key | apt-key add -
aptrepo=updates
# aptrepo=testing    # or use this for the latest, development version
cat <<EOF > /etc/apt/sources.list.d/bluehorizon.list
deb [arch=$(dpkg --print-architecture)] http://pkg.bluehorizon.network/linux/ubuntu xenial-$aptrepo main
deb-src [arch=$(dpkg --print-architecture)] http://pkg.bluehorizon.network/linux/ubuntu xenial-$aptrepo main
EOF

# Install demo dependencies
apt update && apt install -y horizon-wiotp mosquitto-clients curl wget gettext make

# Loand env vars
. ~/hzn_custom_wl_demo.env
export HZN_EXCHANGE_URL="https://$WIOTP_ORG_ID.$WIOTP_DOMAIN/api/v0002/edgenode/"

echo "Running on a production environment"

echo "Checking existing device types for this org..."
hzn wiotp -o $WIOTP_ORG_ID -A "$WIOTP_API_KEY:$WIOTP_API_TOKEN" type list | jq .

echo "$WIOTP_GW_TYPE device type..."
hzn wiotp -o $WIOTP_ORG_ID -A "$WIOTP_API_KEY:$WIOTP_API_TOKEN" type list $WIOTP_GW_TYPE | jq .

echo "All devices of $WIOTP_GW_TYPE device type..."
hzn wiotp -o $WIOTP_ORG_ID -A "$WIOTP_API_KEY:$WIOTP_API_TOKEN" device list $WIOTP_GW_TYPE | jq .

echo "$WIOTP_GW_TYPE $WIOTP_GW_ID device..."
hzn wiotp -o $WIOTP_ORG_ID -A "$WIOTP_API_KEY:$WIOTP_API_TOKEN" device list $WIOTP_GW_TYPE $WIOTP_GW_ID | jq .

echo "Cleanning up environment from previous executions... " 
echo ""
hzn unregister -f >/dev/null
if [ $? -eq 0 ]; then
    echo "Cleanning up environment finished" 
else
    echo "No previous executions. Please ignore the error message above"     
fi
echo ""
echo "Environment configuration complete."
