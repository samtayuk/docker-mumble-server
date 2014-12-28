FROM ubuntu:14.04
MAINTAINER Samuel Taylor "samtaylor.uk@gmail.com"
ENV DEBIAN_FRONTEND noninteractive

# Version
ENV MUMBLE_SERVER_VERSION 1.2.8-1~ppa1~trusty1

# First Super Password
ENV SUPER_PASSWORD password

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7F05CF9E  \
  && echo "deb http://ppa.launchpad.net/mumble/release/ubuntu trusty main" | tee -a /etc/apt/sources.list \
  && apt-get update -q \
  && apt-get install -qy mumble-server=$MUMBLE_SERVER_VERSION \
  ; apt-get clean \
  ; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /config \
  && chown -R nobody:users /config

ADD mumble-server.ini /assets/

ADD start.sh /
RUN chmod +x /start.sh

EXPOSE 64738 64738/udp

VOLUME [/config]

USER nobody
CMD ["/start.sh"]
