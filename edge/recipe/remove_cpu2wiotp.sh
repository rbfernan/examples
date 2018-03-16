#!/bin/bash

# Load env vars
. ~/hzn_custom_wl_demo.env
export HZN_EXCHANGE_URL="https://$WIOTP_ORG_ID.$WIOTP_DOMAIN/api/v0002/edgenode/"

echo ""
echo "Deleting ms definition..."
hzn exchange -u "$WIOTP_API_KEY:$WIOTP_API_TOKEN" microservice remove -o $WIOTP_ORG_ID  internetofthings.ibmcloud.com-microservices-cpu_${CPU_VERSION}_${ARCH2}

echo ""
echo "Deleting wl definition..."
hzn exchange -u "$WIOTP_API_KEY:$WIOTP_API_TOKEN" workload remove -o $WIOTP_ORG_ID  internetofthings.ibmcloud.com-workloads-cpu2wiotp_${CPU2WIOTP_VERSION}_${ARCH2}

echo "" 
echo "Remove Complete."