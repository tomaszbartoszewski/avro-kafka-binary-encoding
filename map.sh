#!/bin/bash

# Publish a map of long

curl -X POST -H "Content-Type: application/vnd.kafka.avro.v2+json" \
      -H "Accept: application/vnd.kafka.v2+json" \
      --data '{"value_schema": "{\"type\":\"map\",\"values\":\"long\"}", "records": [{"value": {"a": 1, "b": -1}}]}' \
      "http://localhost:8082/topics/map_long_data" &>/dev/null


curl -s -X POST -H "Content-Type: application/vnd.kafka.v2+json" \
      --data '{"name": "map_long_data_consumer_instance", "format": "binary", "auto.offset.reset": "earliest"}' \
      http://localhost:8082/consumers/map_long_data_binary_consumer &>/dev/null


curl -s -X POST -H "Content-Type: application/vnd.kafka.v2+json" --data '{"topics":["map_long_data"]}' \
      http://localhost:8082/consumers/map_long_data_binary_consumer/instances/map_long_data_consumer_instance/subscription &>/dev/null


while read -r l; do
    echo "----------"
    echo "In hex"
    echo "$l" | base64 --decode | od -t x1 -Ad
    echo "In binary"
    echo "$l" | base64 --decode | xxd -b
done < <(
curl -s -X GET -H "Accept: application/vnd.kafka.binary.v2+json" \
      http://localhost:8082/consumers/map_long_data_binary_consumer/instances/map_long_data_consumer_instance/records | jq --raw-output '.[].value' \
)


curl -X DELETE -H "Content-Type: application/vnd.kafka.v2+json" \
      http://localhost:8082/consumers/map_long_data_binary_consumer/instances/map_long_data_consumer_instance
