#!/bin/sh
echo "SPEEDD Client - starting"
/usr/sbin/sshd

echo "sshd started, wait till kafka is up"

sleep 30s

if [ -e /var/speedd/speedd-topics-initialized ]
then
	echo "SPEEDD topics exist"
else
	echo "SPEEDD topics do not exist - creating..."
	$KAFKA_HOME/bin/kafka-topics.sh --create --topic speedd-traffic-in-events --replication-factor 1 --partitions 1 --zookeeper zk:2181
	$KAFKA_HOME/bin/kafka-topics.sh --create --topic speedd-traffic-out-events --replication-factor 1 --partitions 1 --zookeeper zk:2181
	$KAFKA_HOME/bin/kafka-topics.sh --create --topic speedd-traffic-actions --replication-factor 1 --partitions 1 --zookeeper zk:2181
	$KAFKA_HOME/bin/kafka-topics.sh --create --topic speedd-traffic-admin --replication-factor 1 --partitions 1 --zookeeper zk:2181
	$KAFKA_HOME/bin/kafka-topics.sh --create --topic speedd-fraud-in-events --replication-factor 1 --partitions 1 --zookeeper zk:2181
	$KAFKA_HOME/bin/kafka-topics.sh --create --topic speedd-fraud-out-events --replication-factor 1 --partitions 1 --zookeeper zk:2181
	$KAFKA_HOME/bin/kafka-topics.sh --create --topic speedd-fraud-actions --replication-factor 1 --partitions 1 --zookeeper zk:2181
	$KAFKA_HOME/bin/kafka-topics.sh --create --topic speedd-fraud-admin --replication-factor 1 --partitions 1 --zookeeper zk:2181
	touch /var/speedd/speedd-topics-initialized
fi

echo "start completed"

#Prevent exit - keep the container running
tail -f /dev/null