#!/bin/bash

# Converts returned data from Kafka from hex to ascii

echo $1 | xxd -r -p
