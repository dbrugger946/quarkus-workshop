#!/bin/bash
echo "Script to generate keystore and kafka client script "
echo "Ensure you are logged into correct OCP cluster via the CLI 'oc' "
echo "May need to adjust scripts for different kafka cluster naming "


# grab the route
route=$(oc get routes my-cluster-kafka-bootstrap -o=jsonpath='{.status.ingress[0].host}')
route=${route}:443
echo $route

# pull the TLS cert from the broker
oc extract secret/my-cluster-cluster-ca-cert --keys=ca.crt --to=- > generated/ca.crt

keyfile='generated/truststore.jks'

# if a truststore.jks file already exists then delete it
if [ -f $keyfile  ]; then
	echo "Deleting existing -- $keyfile"
	rm $keyfile
fi

# push the the cert into a Java keystore
keytool -import -trustcacerts -alias root -file generated/ca.crt -keystore $keyfile -storepass password -noprompt

# create the client kafka scripts
cat <<EOF > generated/lis-names.sh
	kafka-console-consumer.sh --bootstrap-server $route \\
   	--consumer-property security.protocol=SSL --consumer-property ssl.truststore.password=password \\
	--topic names --from-beginning \\
	--consumer-property ssl.truststore.location=truststore.jks
EOF
chmod +x generated/lis-names.sh

cat <<EOF > generated/pro-names.sh
        kafka-console-producer.sh --bootstrap-server $route \\
        --producer-property security.protocol=SSL --producer-property ssl.truststore.password=password \\
        --topic names \\
        --producer-property ssl.truststore.location=truststore.jks
EOF
chmod +x generated/pro-names.sh

exit 0
