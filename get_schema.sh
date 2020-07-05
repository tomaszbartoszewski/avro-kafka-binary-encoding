#!/bin/bash

# Calls Schema registry, needs id of the schema as parameter

curl -s -X GET http://0.0.0.0:8081/schemas/ids/$1 | jq -r '.schema' | jq .
