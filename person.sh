#!/bin/bash

# Publish two people description


curl -X POST -H "Content-Type: application/vnd.kafka.avro.v2+json" \
      -H "Accept: application/vnd.kafka.v2+json" \
      --data '{"value_schema": "{\"type\":\"record\",\"name\":\"Person\",\"fields\":[{\"name\":\"name\",\"type\": \"string\"},{\"name\":\"age\",\"type\": \"int\"},{\"name\": \"eyesColour\",\"type\": {\"name\": \"enumEyesColour\",\"symbols\": [\"amber\", \"blue\", \"brown\", \"gray\", \"green\", \"hazel\", \"red\"],\"type\": \"enum\"}}]}", "records": [{"value": {"name": "Debra","age": 56,"eyesColour": "blue"}}, {"value": {"name": "John","age": 67,"eyesColour": "hazel"}}]}' \
      "http://localhost:8082/topics/person_data" &>/dev/null


curl -s -X POST -H "Content-Type: application/vnd.kafka.v2+json" \
      --data '{"name": "person_data_consumer_instance", "format": "binary", "auto.offset.reset": "earliest"}' \
      http://localhost:8082/consumers/person_data_binary_consumer &>/dev/null


curl -s -X POST -H "Content-Type: application/vnd.kafka.v2+json" --data '{"topics":["person_data"]}' \
      http://localhost:8082/consumers/person_data_binary_consumer/instances/person_data_consumer_instance/subscription &>/dev/null


while read -r l; do
    echo "----------"
    echo "In hex"
    echo "$l" | base64 --decode | od -t x1 -Ad
    echo "In binary"
    echo "$l" | base64 --decode | xxd -b
done < <(
curl -s -X GET -H "Accept: application/vnd.kafka.binary.v2+json" \
      http://localhost:8082/consumers/person_data_binary_consumer/instances/person_data_consumer_instance/records | jq --raw-output '.[].value' \
)


curl -X DELETE -H "Content-Type: application/vnd.kafka.v2+json" \
      http://localhost:8082/consumers/person_data_binary_consumer/instances/person_data_consumer_instance
