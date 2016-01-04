FROM node:4.2
MAINTAINER kofman-alex 

RUN echo 'root:speedd' | chpasswd

RUN apt-get update; apt-get install -y openssh-server net-tools

RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

EXPOSE 22

EXPOSE 3000

ADD start-ui.sh /opt/start-ui.sh
RUN chmod 776 /opt/start-ui.sh

CMD /opt/start-ui.sh
