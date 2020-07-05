#!/bin/bash

# Create a consumer for binary data in user_data topic

curl -s -X POST -H "Content-Type: application/vnd.kafka.v2+json" \
      --data '{"name": "user_data_consumer_instance", "format": "binary", "auto.offset.reset": "earliest"}' \
      http://localhost:8082/consumers/user_data_binary_consumer &>/dev/null


curl -s -X POST -H "Content-Type: application/vnd.kafka.v2+json" --data '{"topics":["user_data"]}' \
      http://localhost:8082/consumers/user_data_binary_consumer/instances/user_data_consumer_instance/subscription &>/dev/null


curl -s -X GET -H "Accept: application/vnd.kafka.binary.v2+json" \
      http://localhost:8082/consumers/user_data_binary_consumer/instances/user_data_consumer_instance/records | jq .


curl -X DELETE -H "Content-Type: application/vnd.kafka.v2+json" \
      http://localhost:8082/consumers/user_data_binary_consumer/instances/user_data_consumer_instance
