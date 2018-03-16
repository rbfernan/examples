#!/bin/bash

echo "Running agent setup ..." 
. ~/hzn_custom_wl_demo.env
echo ""
# Setting params for the hznEdgeCoreIoTInput.json.template substitution
export WIOTP_CLASS_ID="Gateway"
export WIOTP_DEVICE_TYPE=$WIOTP_GW_TYPE
export WIOTP_DEVICE_ID=$WIOTP_GW_ID
export WIOTP_DEVICE_AUTH_TOKEN=$WIOTP_GW_TOKEN

echo "Updating the /etc/wiotp-edge/hznEdgeCoreIoTInput.json.template" 
cp /etc/wiotp-edge/hznEdgeCoreIoTInput.json.template /etc/wiotp-edge/hznEdgeCoreIoTInput.json.template.orig
envsubst <~/examples/edge/wiotp/cpu2wiotp/horizon/pattern/device/hznEdgeCoreIoTInput.json.template> /etc/wiotp-edge/hznEdgeCoreIoTInput.json.template

echo "Configuring WIoTP Edge Node for $WIOTP_ORG_ID $WIOTP_GW_TYPE $WIOTP_GW_ID..." 
wiotp_agent_setup --org $WIOTP_ORG_ID --deviceType $WIOTP_GW_TYPE --deviceId $WIOTP_GW_ID --deviceToken "$WIOTP_GW_TOKEN" -cn 'edge-connector'
if [ $? -eq 0 ]; then
    echo "Agent setup ran successfuly"
else
    echo "Agent setup failed to run"
    exit 1
fi

echo "Checking WIoTP Edge Node status..."
hzn node list | jq .configstate.state

echo "Chekcing installed services..."
hzn service registered | jq .

echo "Checking Agreements..."
hzn agreement list | jq . 
echo "If no agreements were generated, wait few seconds and run the check again -> hzn agreement list | jq ."
