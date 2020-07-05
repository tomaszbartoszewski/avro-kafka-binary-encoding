#!/bin/bash

# Publish user records which have one string field called name

curl -X POST -H "Content-Type: application/vnd.kafka.avro.v2+json" \
      -H "Accept: application/vnd.kafka.v2+json" \
      --data '{"value_schema": "{\"type\": \"record\", \"name\": \"User\", \"fields\": [{\"name\": \"name\", \"type\": \"string\"}]}", "records": [{"value": {"name": "Aragorn"}},{"value": {"name": "Galadriel"}},{"value": {"name": "Gimli"}},{"value": {"name": "Arwen"}}]}' \
      "http://localhost:8082/topics/user_data"
