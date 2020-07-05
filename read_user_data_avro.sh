#!/bin/bash

# Create a consumer for avro data in user_data topic

curl -X POST  -H "Content-Type: application/vnd.kafka.v2+json" \
      --data '{"name": "user_data_avro_consumer_instance", "format": "avro", "auto.offset.reset": "earliest"}' \
      http://localhost:8082/consumers/user_data_avro_consumer  &>/dev/null


curl -X POST -H "Content-Type: application/vnd.kafka.v2+json" --data '{"topics":["user_data"]}' \
      http://localhost:8082/consumers/user_data_avro_consumer/instances/user_data_avro_consumer_instance/subscription  &>/dev/null


curl -s -X GET -H "Accept: application/vnd.kafka.avro.v2+json" \
      http://localhost:8082/consumers/user_data_avro_consumer/instances/user_data_avro_consumer_instance/records | jq .


curl -X DELETE -H "Content-Type: application/vnd.kafka.v2+json" \
      http://localhost:8082/consumers/user_data_avro_consumer/instances/user_data_avro_consumer_instance
