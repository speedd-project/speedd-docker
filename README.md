# speedd-docker
Dockerized setup of SPEEDD environment

This project configures the SPEEDD multi-node dockerized environment. It's comprised of the following components:


1. Zookeeper
2. Storm cluster:
  - Storm nimbus
  - Storm supervisor
  - Storm UI
3. Kafka broker
4. SPEEDD UI
5. SPEEDD client

## Pre-requisites
1. Install docker toolkit:
  * [Windows](https://docs.docker.com/engine/installation/windows/)
  * [Mac OS X](https://docs.docker.com/engine/installation/mac/)

  **Note:** Because of an [issue](https://github.com/docker/docker/issues/18180#issuecomment-162568282) with default docker machine you have to create a new machine with overlay storage driver using the following command:
  
  `docker-machine create -d virtualbox --engine-storage-driver overlay overlay`
  
  After creating the overlay machine please update the start.sh file under your Docker Toolbox installation folder to have the following line:<br>
  Instead of: `VM=default`<br>
  Should be: `VM=overlay` 
  
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
4. Create the 'projects' folder in your home directory and check out the speedd project's source code into it. Then build the speedd-runtime project (`mvn clean install -DskipTests assembly:assembly` - run it from the speedd-runtime folder)

## Usage
Start a SPEEDD cluster for traffic management use case:<br>
- `docker-compose -f docker-compose.yml -f docker-compose-tm.yml up -d`<br>

 **Note:** The client and UI containers will wait for 2 minutes to have the kafka brokers up and topics initialized. Also, it might take a few minutes to storm cluster to fully initialize. Please take this into account before accessing the UI or starting SPEEDD topology.<br>
 
Start a SPEEDD cluster for credit card fraud management use case:
- `docker-compose -f docker-compose.yml -f docker-compose-ccf.yml up -d`

Destroy the SPEEDD cluster:
- `docker-compose  -f docker-compose.yml  -f docker-compose-tm.yml stop`

Open SSH to the client:
  `ssh root@<docker-machine-ip> -p 49022`

**Note:** *The password is initialized to 'speedd'*

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
  4. [node-docker](https://github.com/nodejs/docker-node)
