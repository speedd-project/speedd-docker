FROM wurstmeister/base

MAINTAINER Alex Kofman

RUN echo 'root:speedd' | chpasswd

RUN wget -q -O - http://mirrors.sonic.net/apache/storm/apache-storm-0.9.4/apache-storm-0.9.4.tar.gz | tar -xzf - -C /opt

ENV STORM_HOME /opt/apache-storm-0.9.4

RUN ln -s $STORM_HOME/bin/storm /usr/bin/storm

ADD storm.yaml $STORM_HOME/conf/storm.yaml


ENV KAFKA_VERSION="0.8.2.1" SCALA_VERSION="2.10"

RUN apt-get update && apt-get install -y unzip curl git docker.io jq

ADD download-kafka.sh /tmp/download-kafka.sh
RUN chmod 776 /tmp/download-kafka.sh
RUN /tmp/download-kafka.sh
RUN tar xf /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt

VOLUME ["/kafka"]

ENV KAFKA_HOME /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}
ADD broker-list.sh /usr/bin/broker-list.sh
RUN chmod 776 /usr/bin/broker-list.sh

ADD start-client.sh /opt/start-client.sh
RUN chmod 776 /opt/start-client.sh

RUN mkdir /var/speedd

CMD /opt/start-client.sh


