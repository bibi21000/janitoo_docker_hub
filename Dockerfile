FROM python:2.7.11

MAINTAINER bibi21000 <bibi21000@gmail.com>

RUN cat /etc/issue
RUN env
RUN /sbin/ip addr

RUN apt-get update && \
    apt-get install -y build-essential libwrap0-dev libc-ares-dev python-dev && \
    apt-get dist-upgrade -y && \
    apt-get install -y sudo openssh-server && \
    mkdir -p /var/run/sshd && \
    apt-get install -y sudo supervisor && \
    mkdir -p /var/log/supervisor && \
    apt-get clean && \
    rm -Rf /root/.cache/*

COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir /opt/janitoo && \
    for dir in src home log run etc init; do mkdir /opt/janitoo/$dir; done && \
    mkdir /opt/janitoo/src/janitoo_docker_hub

ADD . /opt/janitoo/src/janitoo_docker_hub

WORKDIR /opt/janitoo/src/janitoo_docker_hub

RUN make deps && \
    make develop && \
    apt-get clean && \
    [ -d /root/.cache ] && rm -Rf /root/.cache/*

CMD ["/usr/bin/supervisord", "--nodaemon"]
