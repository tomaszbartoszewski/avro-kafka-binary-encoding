#!/bin/bash

# Publish multiple messages with nullable long schema, read them and print in hex and binary

curl -X POST -H "Content-Type: application/vnd.kafka.avro.v2+json" \
      -H "Accept: application/vnd.kafka.v2+json" \
      --data '{"value_schema": "{\"type\":\"record\",\"name\":\"NullableInt\",\"fields\": [{\"name\":\"favoriteNumber\",\"type\":[\"null\", \"long\"],\"default\": null}]}", "records": [{"value": {"favoriteNumber": null}},{"value": {"favoriteNumber": {"long": 1337}}},{"value": {"favoriteNumber": {"long": 2}}},{"value": {"favoriteNumber": {"long": 64}}},{"value": {"favoriteNumber": {"long": 8192}}}]}' \
      "http://localhost:8082/topics/nullable_int_data" &>/dev/null


curl -s -X POST -H "Content-Type: application/vnd.kafka.v2+json" \
      --data '{"name": "nullable_int_data_consumer_instance", "format": "binary", "auto.offset.reset": "earliest"}' \
      http://localhost:8082/consumers/nullable_int_data_binary_consumer &>/dev/null


curl -s -X POST -H "Content-Type: application/vnd.kafka.v2+json" --data '{"topics":["nullable_int_data"]}' \
      http://localhost:8082/consumers/nullable_int_data_binary_consumer/instances/nullable_int_data_consumer_instance/subscription &>/dev/null


while read -r l; do
    echo "----------"
    echo "In hex"
    echo "$l" | base64 --decode | od -t x1 -Ad
    echo "In binary"
    echo "$l" | base64 --decode | xxd -b
done < <(
curl -s -X GET -H "Accept: application/vnd.kafka.binary.v2+json" \
      http://localhost:8082/consumers/nullable_int_data_binary_consumer/instances/nullable_int_data_consumer_instance/records | jq --raw-output '.[].value' \
)


curl -X DELETE -H "Content-Type: application/vnd.kafka.v2+json" \
      http://localhost:8082/consumers/nullable_int_data_binary_consumer/instances/nullable_int_data_consumer_instance
