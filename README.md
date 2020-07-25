# Scripts to play with Avro binary encoding in Kafka

## Resources

https://docs.confluent.io/current/schema-registry/serdes-develop/index.html#wire-format

https://avro.apache.org/docs/1.7.7/spec.html#binary_encoding

https://docs.confluent.io/current/kafka-rest/quickstart.html

https://docs.confluent.io/current/schema-registry/develop/api.html

https://github.com/confluentinc/cp-all-in-one

## Requirements

* To run Kafka you will need Docker Compose
* The scripts are using:
    * curl
    * base64
    * od
    * xxd
    * jq

## How to run it

First you have to start Zookeeper, Kafka, Schema Registry and REST Proxy in Docker Compose

```
docker-compose up
```

Once it started you can run following scripts.

Publish messages with int schema.
```
./publish_int.sh
```

Read messages (you may have to run it twice, as first time registering a consumer takes a bit longer and it doesn't return yet any messages).
```
./read_int.sh
```

Record with string field.
```
./publish_user_data.sh
```

Create a consumer for avro data.
```
./read_user_data_avro.sh
```

Create a consumer for binary data.
```
./read_user_data_binary.sh
```

Publish and read messages with nullable long schema.
```
./nullable_long.sh
```

Publish and read messages with union of three types schema.
```
./union.sh
```

Publish and read message which is a map of longs values.
```
./map.sh
```

Publish and read messages of complex object with enum.
```
./person.sh
```

Publish and read message with complex object.
```
./complex_object.sh
```

Helper scripts allow you to convert base64 data into hex or binary.
```
./tohex.sh
```

```
./tobinary.sh
```

To convert hex values to ascii.
```
./tostr.sh "30 31"
```

Get schema from Schema registry with schema id.
```
./get_schema.sh 1
```
