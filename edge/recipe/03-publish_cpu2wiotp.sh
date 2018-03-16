#!/bin/bash

# Load env vars
. ~/hzn_custom_wl_demo.env
export HZN_EXCHANGE_URL="https://$WIOTP_ORG_ID.$WIOTP_DOMAIN/api/v0002/edgenode/"

# based on the  https://github.com/open-horizon/examples/wiki/Edge-Quick-Start-Developer-Guide
# Note: requires some of the steps require root access
rm -rf ~/examples

cd ~
git clone https://github.com/rbfernan/examples.git

cd ~/examples/edge/services/cpu_percent
VERSION=$CPU_VERSION make          # build the CPU microservice

cd ~/examples/edge/wiotp/cpu2wiotp
VERSION=$CPU2WIOTP_VERSION make          # build the example workload

#Build docker images
echo "Login into Docker Hub --username=$DOCKER_HUB_ID"
echo ${DOCKER_HUB_ID_PWD} > ~/docker-hub-pwd.txt
cat  ~/docker-hub-pwd.txt | docker login --username=${DOCKER_HUB_ID} --password-stdin
if [ $? -eq 0 ]; then
    echo "Docker hub logged in successfully"
else
    echo "Could not loggin to Docker Hub via script. Please try a manual login before running the script."
    exit
fi
rm -f ~/docker-hub-pwd.txt 

docker tag example_ms_${ARCH2}_cpu:$CPU_VERSION $DOCKER_HUB_ID/example_ms_${ARCH2}_cpu:$CPU_VERSION
docker tag example_wl_${ARCH2}_cpu2wiotp:$CPU2WIOTP_VERSION $DOCKER_HUB_ID/example_wl_${ARCH2}_cpu2wiotp:$CPU2WIOTP_VERSION

echo ""
echo "Pushing microservice image"
docker push $DOCKER_HUB_ID/example_ms_${ARCH2}_cpu:$CPU_VERSION

echo ""
echo "Pushing workload image"
docker push $DOCKER_HUB_ID/example_wl_${ARCH2}_cpu2wiotp:$CPU2WIOTP_VERSION

# get the keys genarated in the previous step. Make sure only one key pair is stored in there
cd ~

# removing old keys
rm ${ARCH2}-*-private.key ${ARCH2}-*-public.pem
hzn key create "${ARCH2}-cpu2witop-keys" 'cpu2wiopt@wiopt.ibm.com' -l 2048 --import
echo ""

for filename in ~/${ARCH2}*-private.key; do
    privateKey=$filename
done
for filename in ~/${ARCH2}*-public.pem; do
    publicKey=$filename
done

echo PRIVATE_KEY_FILE=$privateKey    
export PRIVATE_KEY_FILE=$privateKey    # set to the key that was created

echo PUBLIC_KEY_FILE=$publicKey  
export PUBLIC_KEY_FILE=$publicKey   # set to the key that was created

echo ""
echo "Publishing microservice definition..." 
echo ""
envsubst < ~/examples/edge/services/cpu_percent/horizon/cpu-template.json > ~/ms_def.json
hzn exchange -u "$WIOTP_API_KEY:$WIOTP_API_TOKEN" microservice publish -o $WIOTP_ORG_ID -k $PRIVATE_KEY_FILE -f ~/ms_def.json

echo ""
echo "Checking the pubished ms definition..." 
hzn exchange -u "$WIOTP_API_KEY:$WIOTP_API_TOKEN" microservice list -o $WIOTP_ORG_ID | jq .

echo ""
echo "Verifying ms definition..."
hzn exchange -u "$WIOTP_API_KEY:$WIOTP_API_TOKEN" microservice verify -o $WIOTP_ORG_ID -k $PUBLIC_KEY_FILE internetofthings.ibmcloud.com-microservices-cpu_${CPU_VERSION}_${ARCH2}

echo ""
echo "Publishing workload definition..." 
echo ""
envsubst < ~/examples/edge/wiotp/cpu2wiotp/horizon/cpu2wiotp-template.json > ~/wl_def.json
hzn exchange -u "$WIOTP_API_KEY:$WIOTP_API_TOKEN" workload publish -o $WIOTP_ORG_ID -k $PRIVATE_KEY_FILE -f ~/wl_def.json

echo ""
echo "Checking the pubished wl definition..." 
hzn exchange -u "$WIOTP_API_KEY:$WIOTP_API_TOKEN" workload list -o $WIOTP_ORG_ID | jq .

echo ""
echo "Verifying wl definition..."
hzn exchange -u "$WIOTP_API_KEY:$WIOTP_API_TOKEN" workload verify -o $WIOTP_ORG_ID -k $PUBLIC_KEY_FILE internetofthings.ibmcloud.com-workloads-cpu2wiotp_${CPU2WIOTP_VERSION}_${ARCH2}

echo "" 
echo "Publishing Complete."