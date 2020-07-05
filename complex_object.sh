#!/bin/bash

# Read schema and message from files

schema=$(cat worker.avsc | tr -d '\n ' | sed -E 's/"/\\"/g')
message=$(cat worker_message_value.json | tr -d '\n ')

# Publish message to Kafka

curl -X POST -H "Content-Type: application/vnd.kafka.avro.v2+json" \
      -H "Accept: application/vnd.kafka.v2+json" \
      --data '{"value_schema": "'$schema'", "records": [{"value": '$message'}]}' \
      "http://localhost:8082/topics/factory_worker"

# Create a consumer for Avro data

curl -X POST  -H "Content-Type: application/vnd.kafka.v2+json" \
      --data '{"name": "factory_worker_avro_consumer_instance", "format": "avro", "auto.offset.reset": "earliest"}' \
      http://localhost:8082/consumers/factory_worker_avro_consumer  &>/dev/null


curl -X POST -H "Content-Type: application/vnd.kafka.v2+json" --data '{"topics":["factory_worker"]}' \
      http://localhost:8082/consumers/factory_worker_avro_consumer/instances/factory_worker_avro_consumer_instance/subscription  &>/dev/null


curl -s -X GET -H "Accept: application/vnd.kafka.avro.v2+json" \
      http://localhost:8082/consumers/factory_worker_avro_consumer/instances/factory_worker_avro_consumer_instance/records | jq .


curl -X DELETE -H "Content-Type: application/vnd.kafka.v2+json" \
      http://localhost:8082/consumers/factory_worker_avro_consumer/instances/factory_worker_avro_consumer_instance

# Create a consumer for binary data

curl -s -X POST -H "Content-Type: application/vnd.kafka.v2+json" \
      --data '{"name": "factory_worker_consumer_instance", "format": "binary", "auto.offset.reset": "earliest"}' \
      http://localhost:8082/consumers/factory_worker_binary_consumer &>/dev/null


curl -s -X POST -H "Content-Type: application/vnd.kafka.v2+json" --data '{"topics":["factory_worker"]}' \
      http://localhost:8082/consumers/factory_worker_binary_consumer/instances/factory_worker_consumer_instance/subscription &>/dev/null


curl -s -X GET -H "Accept: application/vnd.kafka.binary.v2+json" \
      http://localhost:8082/consumers/factory_worker_binary_consumer/instances/factory_worker_consumer_instance/records | jq .


curl -X DELETE -H "Content-Type: application/vnd.kafka.v2+json" \
      http://localhost:8082/consumers/factory_worker_binary_consumer/instances/factory_worker_consumer_instance
