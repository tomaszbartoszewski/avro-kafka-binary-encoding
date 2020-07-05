#!/bin/bash

# Converts returned data from Kafka to human readable binary format

echo -n $1 | base64 --decode | xxd -b
