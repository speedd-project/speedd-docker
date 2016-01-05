# speedd-docker
Dockerized setup of SPEEDD environment

This project configures the SPEEDD multi-node dockerized environment. It's comprised of the following components:
1. Zookeeper
2. Storm cluster:
  1. Storm nimbus
  2. Storm supervisor
  3. Storm UI
3. Kafka broker
4. SPEEDD UI
5. SPEEDD client

## Pre-requisites
1. Install docker toolkit:
  * [Windows](https://docs.docker.com/engine/installation/windows/)
  * [Mac OS X](https://docs.docker.com/engine/installation/mac/)
2. Start docker-machine and open the terminal window (e.g. Docker Quickstart Terminal)
3. Build prerequisite images (this step is required because we use our own forked version of the storm and kafka images)
  3.1 Build storm images
    1. clone https://github.com/speedd-project/storm-docker.git
    2. cd storm-docker
    3. ./rebuild.sh
  3.2 Build kafka image
    1. clone https://github.com/speedd-project/kafka-docker.git
    2. cd kafka-docker
    3. docker build -t wurstmeister/kafka-docker --rm=true .

## Usage
Start a SPEEDD cluster for traffic management use case:
- `docker-compose -f docker-compose-tm.yml up -d`

Start a SPEEDD cluster for credit card fraud management use case:
- `docker-compose -f docker-compose-ccf.yml up -d`

Destroy the SPEEDD cluster:
- `docker-compose stop`

Open SSH to the client:
  1. `docker-compose -f <docker-compose-tm.yml | docker-compose-ccf.yml> ps` - will print information about the running containers that comprise the cluster.
    * Example:
    ```
    $ docker-compose.exe -f docker-compose-tm.yml ps

          Name                         Command               State   Ports
---------------------------------------------------------------------------------------------------------------------------------------------------------------
speedddocker_client_1       /bin/sh -c /opt/start-clie ...   Up      0.0.0.0:32806->22/tcp
speedddocker_kafka_1        /bin/sh -c start-kafka.sh        Up      0.0.0.0:59092->9092/tcp
speedddocker_nimbus_1       /bin/sh -c /usr/bin/start- ...   Up      0.0.0.0:32803->22/tcp, 0.0.0.0:49772->3772/tcp, 0.0.0.0:49773->3773/tcp, 0.0.0.0:49627->6627/tcp
speedddocker_storm-ui_1     /bin/sh -c /usr/bin/start- ...   Up      0.0.0.0:32808->22/tcp, 0.0.0.0:49080->8080/tcp
speedddocker_supervisor_1   /bin/sh -c /usr/bin/start- ...   Up      0.0.0.0:32805->22/tcp, 6700/tcp, 6701/tcp, 6702/tcp, 6703/tcp, 0.0.0.0:32804->8000/tcp
speedddocker_ui_1           /bin/sh -c /opt/start-ui.sh      Up      0.0.0.0:32807->22/tcp, 0.0.0.0:43000->3000/tcp
speedddocker_zookeeper_1    /bin/sh -c /usr/sbin/sshd  ...   Up      0.0.0.0:49181->2181/tcp, 0.0.0.0:32802->22/tcp, 2888/tcp, 3888/tcp
  ```
  2. `ssh root@<docker-machine-ip> -p <client ssh port>` - where the client ssh port in the example above is 32806

Deploy SPEEDD topology (example for the traffic management use case):
  1. Open ssh to the client container
  2. `cd /opt/src/speedd/speedd-runtime/scripts/traffic`
  3. `./start-speedd-runtime-docker`

Stream events into SPEEDD (example for the traffic management use case):
  1. Open ssh to the client container
  2. `cd /opt/src/speedd/speedd-runtime/scripts/traffic`
  3. `playevents-traffic-docker`

Open SPEEDD UI:
- open http://\<docker-machine-ip\>:43000 in your browser

Open Storm UI:
- open http://\<docker-machine-ip\>:49080 in your browser

## Dependencies:
  1. [storm-docker](https://github.com/speedd-project/storm-docker.git)
  2. [kafka-docker](https://github.com/speedd-project/kafka-docker.git)
  3. [zookeeper-docker](https://github.com/wurstmeister/zookeeper-docker.git)
