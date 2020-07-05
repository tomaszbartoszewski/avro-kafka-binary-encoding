#!/bin/bash

# Converts returned data from Kafka to human readable hex format

echo -n $1 | base64 --decode | od -t x1 -Ad
