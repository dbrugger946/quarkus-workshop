        kafka-console-producer.sh --bootstrap-server my-cluster-kafka-bootstrap-quarkus-workshop.apps-crc.testing:443 \
        --producer-property security.protocol=SSL --producer-property ssl.truststore.password=password \
        --topic names \
        --producer-property ssl.truststore.location=truststore.jks
