#!/bin/bash

# Publish multiple messages (integers) with int schema

curl -X POST -H "Content-Type: application/vnd.kafka.avro.v2+json" \
      -H "Accept: application/vnd.kafka.v2+json" \
      --data '{"value_schema": "\"int\"", "records": [{"value": 0},{"value": 1},{"value": 2},
      {"value": 3},{"value": 4},{"value": 64},{"value": 65},{"value": 128}]}' \
      "http://localhost:8082/topics/int_data"
