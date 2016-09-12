FROM armv7/armhf-debian

MAINTAINER jakub.blaszczyk@sap.com

ENV DEBIAN_FRONTEND noninteractive

ADD files/default/qemu-arm-static /usr/bin/

RUN apt-get update
RUN apt-get install -y --no-install-recommends chef
