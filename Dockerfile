FROM armv7/armhf-debian

MAINTAINER jakub.blaszczyk@sap.com

ENV DEBIAN_FRONTEND noninteractive

ADD files/default/qemu-arm-static /usr/bin/

RUN apt-get -qq update
RUN apt-get -qq install -o=Dpkg::Use-Pty=0 -y --no-install-recommends chef > /dev/null

RUN mkdir -p /opt/chef/embedded/bin
RUN ln -s /usr/bin/gem /opt/chef/embedded/bin/gem
RUN ln -s /usr/bin/ruby /opt/chef/embedded/bin/ruby
