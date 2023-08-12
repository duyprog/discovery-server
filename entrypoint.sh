# echo "The application will start in ${APP_DELAY_START}s..." && sleep ${APP_DELAY_START}

EUREKA_INSTANCE_IP_ADDRESS=$(curl -s ${ECS_CONTAINER_METADATA_URI_V4} | jq -r .Networks[0].IPv4Addresses[0])
echo "The eureka ip address ${EUREKA_INSTANCE_IP_ADDRESS}"

exec java \
  -Deureka.instance.ip-address=${EUREKA_INSTANCE_IP_ADDRESS} \
  -jar "./eureka.jar"