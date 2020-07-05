#!/bin/bash

# Create a consumer for binary data in topic with int messages

curl -s -X POST -H "Content-Type: application/vnd.kafka.v2+json" \
      --data '{"name": "int_data_consumer_instance", "format": "binary", "auto.offset.reset": "earliest"}' \
      http://localhost:8082/consumers/int_data_binary_consumer


curl -s -X POST -H "Content-Type: application/vnd.kafka.v2+json" --data '{"topics":["int_data"]}' \
      http://localhost:8082/consumers/int_data_binary_consumer/instances/int_data_consumer_instance/subscription

echo ""
curl -s -X GET -H "Accept: application/vnd.kafka.binary.v2+json" \
      http://localhost:8082/consumers/int_data_binary_consumer/instances/int_data_consumer_instance/records | jq . # | jq '.[].value'


curl -X DELETE -H "Content-Type: application/vnd.kafka.v2+json" \
      http://localhost:8082/consumers/int_data_binary_consumer/instances/int_data_consumer_instance
