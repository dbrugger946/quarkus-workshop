	kafka-console-consumer.sh --bootstrap-server my-cluster-kafka-bootstrap-quarkus-workshop.apps-crc.testing:443 \
   	--consumer-property security.protocol=SSL --consumer-property ssl.truststore.password=password \
	--topic names --from-beginning \
	--consumer-property ssl.truststore.location=truststore.jks
