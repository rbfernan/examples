#!/bin/bash

# Configuration section 
# Create env vars used by the script
#
cat <<EOF > ~/hzn_custom_wl_demo.env

export WIOTP_DOMAIN=internetofthings.ibmcloud.com
export WIOTP_CLASS_ID="g"          # g (gateway) or d (device)

# These values contain the credentials you created earlier in the Watson IoT Platform web GUI
# Replace the <placeHolders> with the approriate values
export WIOTP_ORG_ID=<orgId>
export WIOTP_GW_TYPE=<gatewayType>
export WIOTP_GW_ID=<deviceId>
export WIOTP_GW_TOKEN=<password>
export WIOTP_API_KEY='<ApiKey>'
export WIOTP_API_TOKEN='<ApiToken>'

# This variable must be set appropriately for your specific Edge Node
export ARCH2=amd64   # or arm for Raspberry Pi, or arm64 for TX2

# Specify the docker registry prefix for "docker pull" commands
# If you are using Docker Hub, this is simply your Docker Hub user name
export DOCKER_HUB_ID=<DockerHubId>
export DOCKER_HUB_ID_PWD=<DockerHubIdPassword>

# Freely edit the variables below for software version management as you change the example code
export CPU_VERSION=1.2.2
export CPU2WIOTP_VERSION=1.1.8
EOF

echo "Configuration file created at ~/hzn_custom_wl_demo.env "
