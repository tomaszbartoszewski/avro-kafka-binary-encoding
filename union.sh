#!/bin/bash

# Publish a union of 3 types, null, int, string

curl -X POST -H "Content-Type: application/vnd.kafka.avro.v2+json" \
      -H "Accept: application/vnd.kafka.v2+json" \
      --data '{"value_schema": "{\"type\":\"record\",\"name\":\"UnionExample\",\"fields\": [{\"name\":\"valueA\",\"type\":[\"null\", \"int\", \"string\"],\"default\": null}]}", "records": [{"value": {"valueA": null}}, {"value": {"valueA": {"int": 4}}}, {"value": {"valueA": {"string": "C"}}}]}' \
      "http://localhost:8082/topics/union_data" &>/dev/null


curl -s -X POST -H "Content-Type: application/vnd.kafka.v2+json" \
      --data '{"name": "union_data_consumer_instance", "format": "binary", "auto.offset.reset": "earliest"}' \
      http://localhost:8082/consumers/union_data_binary_consumer &>/dev/null


curl -s -X POST -H "Content-Type: application/vnd.kafka.v2+json" --data '{"topics":["union_data"]}' \
      http://localhost:8082/consumers/union_data_binary_consumer/instances/union_data_consumer_instance/subscription &>/dev/null


while read -r l; do
    echo "----------"
    echo "In hex"
    echo "$l" | base64 --decode | od -t x1 -Ad
    echo "In binary"
    echo "$l" | base64 --decode | xxd -b
done < <(
curl -s -X GET -H "Accept: application/vnd.kafka.binary.v2+json" \
      http://localhost:8082/consumers/union_data_binary_consumer/instances/union_data_consumer_instance/records | jq --raw-output '.[].value' \
)


curl -X DELETE -H "Content-Type: application/vnd.kafka.v2+json" \
      http://localhost:8082/consumers/union_data_binary_consumer/instances/union_data_consumer_instance
